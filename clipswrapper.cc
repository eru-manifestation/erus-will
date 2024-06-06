#include "clipswrapper.h"
#include "clips/clips.h"
#include <string.h>
#include <napi.h>

using namespace std;

Napi::Object ClipsWrapper::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function func =
      DefineClass(env,
                  "ClipsWrapper",
                  {InstanceMethod("createEnvironment", &ClipsWrapper::PromiseCreateEnvironment),
                    InstanceMethod("wrapDestroyEnvironment", &ClipsWrapper::WrapDestroyEnvironment),
                    InstanceMethod("wrapEval", &ClipsWrapper::WrapEval)});

  Napi::FunctionReference* constructor = new Napi::FunctionReference();
  *constructor = Napi::Persistent(func);
  env.SetInstanceData(constructor);

  exports.Set("ClipsWrapper", func);
  return exports;
}

ClipsWrapper::ClipsWrapper(const Napi::CallbackInfo& info)
    : Napi::ObjectWrap<ClipsWrapper>(info) {}

Napi::Value ClipsWrapper::PromiseCreateEnvironment(const Napi::CallbackInfo& info){
  CreateEnvironmentWorker* worker = 
    new CreateEnvironmentWorker(info.Env(), &(this->_clips_env));
  worker->Queue();
  return worker->GetPromise();
}

Napi::Value ClipsWrapper::WrapDestroyEnvironment(const Napi::CallbackInfo& info) {
  DestroyEnvironmentWorker* worker = 
    new DestroyEnvironmentWorker(info.Env(), &(this->_clips_env));
  worker->Queue();
  return worker->GetPromise();
}

Napi::Value ClipsWrapper::WrapEval(const Napi::CallbackInfo& info) {
  string command;
  if (info.Length() <= 0 || !info[0].IsString()) {
    throw Napi::TypeError::New(info.Env(), "Invalid argument, the evaluated order must be a string");
  } else {
    command = info[0].As<Napi::String>().Utf8Value();
  }

  GetContentWorker *worker = 
    new GetContentWorker(info.Env(),&(this->_clips_env),string(command));
  worker->Queue();
  return worker->GetPromise();
}
