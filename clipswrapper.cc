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
  cout << "informacion";
  *(this->result) = string("");
  cout << "Pointer antes\t";
  cout << this->clips_env_;
  cout << endl;
  cout << "Result antes\t";
  cout << *(this->result);
  cout << endl;
  this->clips_env_ = CreateEnvironment();
  cout << Load(this->clips_env_, "load.clp");
  cout << Eval(this->clips_env_, "(load-all)", NULL);
  cout << Run(this->clips_env_, -1);
  
  cout << "Pointer antes de la llamada\t";
  cout << this->clips_env_;
  cout << endl;
  cout << "Result antes de la llamada\t";
  cout << *(this->result);
  cout << endl;
  
  return Napi::Number::New(info.Env(), 1);

  // CreateEnvironmentWorker* worker = new CreateEnvironmentWorker(info.Env(), this->clips_env_, this->result);
  // worker->Queue();
  // return worker->GetPromise();
}

Napi::Value ClipsWrapper::GetFacts(const Napi::CallbackInfo& info) {
  //String num = this->CLIPSenv;
  //TODO: Devolver hechos
  CLIPSValue cv;
  // Eval(this->clips_env_, "(do-for-)")
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
  cout << "Pointer despues\t";
  cout << this->clips_env_;
  cout << endl;
  cout << "Result despues\t";
  cout << *(this->result);
  cout << endl;

  string command1 = "(get-content ?*announce-p1*)";
  CLIPSValue cv;
  Eval(this->clips_env_, command1.c_str() ,&cv);
  cout << cv.lexemeValue->contents;
  cout << endl;

  // CLIPSValue cv;
  cout << "Inicia el debug buffer\n";
  cout << this->clips_env_;
  Eval(this->clips_env_, "(get-content ?*debug*)",&cv);
  cout << "Finaliza primera orden del debug buffer\n";
  string res = cv.lexemeValue->contents;
  cout << "Finaliza segunda orden del debug buffer\n";
  Eval(this->clips_env_, "(bind ?*debug* (create$))",NULL);
  cout << "Finaliza tercira y ultima orden del debug buffer\n";
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
