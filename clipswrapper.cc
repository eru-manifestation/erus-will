#include "clipswrapper.h"
#include "clips/clips.h"
#include <string.h>
#include <napi.h>
#include <iostream>

using namespace std;

Napi::Object ClipsWrapper::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function func =
      DefineClass(env,
                  "ClipsWrapper",
                  {InstanceMethod("createEnvironment", &ClipsWrapper::PromiseCreateEnvironment),
                    InstanceMethod("getDebugBuffer", &ClipsWrapper::GetDebugBuffer),
                    InstanceMethod("getAnnounceBuffer", &ClipsWrapper::GetAnnounceBuffer),
                    InstanceMethod("getChooseBuffer", &ClipsWrapper::GetChooseBuffer),
                    InstanceMethod("getStateBuffer", &ClipsWrapper::GetStateBuffer),
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

Napi::Value ClipsWrapper::GetAnnounceBuffer(const Napi::CallbackInfo& info) {
  string multifield;
  if (info.Length() <= 0 || !info[0].IsString()) {
    Napi::TypeError::New(info.Env(), "Player name expected").ThrowAsJavaScriptException();
    return Napi::Boolean::New(info.Env(),false);
  } else {
    string player = info[0].As<Napi::String>().Utf8Value();
    if(strcmp(player.c_str(),"player1")==0){
      multifield = "?*announce-p1*";
    }else if (strcmp(player.c_str(),"player2")==0){
      multifield = "?*announce-p2*";
    }else{
      Napi::TypeError::New(info.Env(), "Invalid player name").ThrowAsJavaScriptException();
      return Napi::Boolean::New(info.Env(),false);
    }
  }

  GetContentWorker *worker = 
    new GetContentWorker(info.Env(),&(this->_clips_env),multifield);
  worker->Queue();
  return worker->GetPromise();
}

Napi::Value ClipsWrapper::GetDebugBuffer(const Napi::CallbackInfo& info) {
  GetContentWorker *worker = 
    new GetContentWorker(info.Env(),&(this->_clips_env),string("?*debug*"));
  worker->Queue();
  return worker->GetPromise();
}

Napi::Value ClipsWrapper::GetChooseBuffer(const Napi::CallbackInfo& info) {
  string multifield;
  if (info.Length() <= 0 || !info[0].IsString()) {
    Napi::TypeError::New(info.Env(), "Player name expected").ThrowAsJavaScriptException();
    return Napi::Boolean::New(info.Env(),false);
  } else {
    string player = info[0].As<Napi::String>().Utf8Value();
    if(strcmp(player.c_str(),"player1")==0){
      multifield = "?*choose-p1*";
    }else if (strcmp(player.c_str(),"player2")==0){
      multifield = "?*choose-p2*";
    }else{
      Napi::TypeError::New(info.Env(), "Invalid player name").ThrowAsJavaScriptException();
      return Napi::Boolean::New(info.Env(),false);
    }
  }

  GetContentWorker *worker = 
    new GetContentWorker(info.Env(),&(this->_clips_env),multifield);
  worker->Queue();
  return worker->GetPromise();
}

Napi::Value ClipsWrapper::GetStateBuffer(const Napi::CallbackInfo& info) {
  string multifield, player;
  if (info.Length() <= 0 || !info[0].IsString()) {
    Napi::TypeError::New(info.Env(), "Player name expected").ThrowAsJavaScriptException();
    return Napi::Boolean::New(info.Env(),false);
  } else {
    player = info[0].As<Napi::String>().Utf8Value();
    if(strcmp(player.c_str(),"player1")==0){
      multifield = "?*state-p1*";
    }else if (strcmp(player.c_str(),"player2")==0){
      multifield = "?*state-p2*";
    }else{
      Napi::TypeError::New(info.Env(), "Invalid player name").ThrowAsJavaScriptException();
      return Napi::Boolean::New(info.Env(),false);
    }
  }

  GetStateWorker *worker = 
    new GetStateWorker(info.Env(), &(this->_clips_env), player, multifield);
  worker->Queue();
  return worker->GetPromise();
}

Napi::Value ClipsWrapper::WrapEval(const Napi::CallbackInfo& info) {
  string command;
  if (info.Length() <= 0 || !info[0].IsString()) {
    Napi::TypeError::New(info.Env(), "Invalid argument, the evaluated order must be a string").ThrowAsJavaScriptException();
    return Napi::Boolean::New(info.Env(),false);
  } else {
    command = info[0].As<Napi::String>().Utf8Value();
  }

  WrapEvalWorker *worker = 
    new WrapEvalWorker(info.Env(), &(this->_clips_env), command);
  worker->Queue();
  return worker->GetPromise();
}
