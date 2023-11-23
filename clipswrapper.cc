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
                    InstanceMethod("getFacts", &ClipsWrapper::GetFacts),
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
  CreateEnvironmentWorker* worker = new CreateEnvironmentWorker(info.Env(), &(this->clips_env_));
  worker->Queue();
  return worker->GetPromise();
}

Napi::Value ClipsWrapper::GetFacts(const Napi::CallbackInfo& info) {
  CLIPSValue cv;
  Eval(this->clips_env_,"(random 0 99)",&cv);
  return Napi::Number::New(info.Env(), cv.integerValue->contents);
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

  string command1 = "(get-content " + multifield + ")";
  string command2 = "(bind " + multifield + " (create$))";
  CLIPSValue cv;
  Eval(this->clips_env_, command1.c_str() ,&cv);
  string res = cv.lexemeValue->contents;
  Eval(this->clips_env_, command2.c_str() ,NULL);
  return Napi::String::New(info.Env(), res);
}

Napi::Value ClipsWrapper::GetDebugBuffer(const Napi::CallbackInfo& info) {
  CLIPSValue cv;
  Eval(this->clips_env_, "(get-content ?*debug*)",&cv);
  string res = cv.lexemeValue->contents;
  Eval(this->clips_env_, "(bind ?*debug* (create$))",NULL);
  return Napi::String::New(info.Env(), res);
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

  string command1 = "(get-content " + multifield + ")";
  string command2 = "(bind " + multifield + " (create$))";
  CLIPSValue cv;
  Eval(this->clips_env_, command1.c_str() ,&cv);
  string res = cv.lexemeValue->contents;
  Eval(this->clips_env_, command2.c_str() ,NULL);
  return Napi::String::New(info.Env(), res);
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

  string command0 = "(update-index (symbol-to-instance-name "+player+"))";
  string command1 = "(get-content " + multifield + ")";
  string command2 = "(bind " + multifield + " (create$))";

  Eval(this->clips_env_, command0.c_str() ,NULL);
  CLIPSValue cv;
  Eval(this->clips_env_, command1.c_str() ,&cv);
  string res = cv.lexemeValue->contents;
  Eval(this->clips_env_, command2.c_str() ,NULL);
  return Napi::String::New(info.Env(), res);
}

Napi::Value ClipsWrapper::WrapDestroyEnvironment(const Napi::CallbackInfo& info) {
  return Napi::Boolean::New(info.Env(), DestroyEnvironment(this->clips_env_));
}

Napi::Value ClipsWrapper::WrapEval(const Napi::CallbackInfo& info) {
  Napi::String command;
  if (info.Length() <= 0 || !info[0].IsString()) {
    command = Napi::String::New(info.Env(), "");
  } else {
    command = info[0].As<Napi::String>();
  }

  CLIPSValue cv;
  Napi::Value napiValue;
  Eval(this->clips_env_, command.Utf8Value().c_str() ,&cv);
  switch(cv.header->type){
    case STRING_TYPE:
    case SYMBOL_TYPE:
      napiValue = Napi::String::New(info.Env(), cv.lexemeValue->contents);
      break;
    case FLOAT_TYPE:
      napiValue = Napi::Number::New(info.Env(), cv.floatValue->contents);
      break;
    case INTEGER_TYPE:
      napiValue = Napi::Number::New(info.Env(), cv.integerValue->contents);
      break;
    default:
      napiValue = Napi::Boolean::New(info.Env(), true);
      break;
  }

  return napiValue;
}
