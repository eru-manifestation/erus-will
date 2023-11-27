#ifndef CLIPSWRAPPER_H
#define CLIPSWRAPPER_H

#include <napi.h>
#include "clips/clips.h"
#include <string> 

using namespace std; 

class ClipsWrapper : public Napi::ObjectWrap<ClipsWrapper> {
 public:
  static Napi::Object Init(Napi::Env env, Napi::Object exports);
  ClipsWrapper(const Napi::CallbackInfo& info);

 private:
  Napi::Value PromiseCreateEnvironment(const Napi::CallbackInfo& info);
  Napi::Value WrapDestroyEnvironment(const Napi::CallbackInfo& info);
  Napi::Value WrapEval(const Napi::CallbackInfo& info);

  Environment *_clips_env;
};


class CreateEnvironmentWorker : public Napi::AsyncWorker {
 public:
  CreateEnvironmentWorker(const Napi::Env& env, Environment** _clips_env)
      : Napi::AsyncWorker{env, "CreateEnvironmentWorker"},
        m_deferred{env},
        _clips_env{_clips_env} {}

  /**
   * GetPromise associated with _deferred for return to JS
   */
  Napi::Promise GetPromise() { return m_deferred.Promise(); }

 protected:
  void Execute() {
    *_clips_env = CreateEnvironment();
    Load(*_clips_env, "load.clp");
    Eval(*_clips_env, "(load-all)", NULL);
    Run(*_clips_env, -1);
    result = string("Environment created");
  }
  void OnOK() { m_deferred.Resolve(Napi::String::New(Env(), result)); }
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment **_clips_env;
  string result;
};


class DestroyEnvironmentWorker : public Napi::AsyncWorker {
 public:
  DestroyEnvironmentWorker(const Napi::Env& env, Environment** _clips_env)
      : Napi::AsyncWorker{env, "DestroyEnvironmentWorker"},
        m_deferred{env},
        _clips_env{_clips_env} {}

  /**
   * GetPromise associated with _deferred for return to JS
   */
  Napi::Promise GetPromise() { return m_deferred.Promise(); }

 protected:
  void Execute() {
    result = Napi::Boolean::New(Env(), DestroyEnvironment(*_clips_env));
  }
  void OnOK() { m_deferred.Resolve(result); }
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment **_clips_env;
  Napi::Value result;
};


class GetContentWorker : public Napi::AsyncWorker {
 public:
  GetContentWorker(const Napi::Env& env, Environment** _clips_env, string content)
      : Napi::AsyncWorker{env, "GetContentWorker"},
        m_deferred{env},
        _clips_env{_clips_env},
        content{content} {}

  /**
   * GetPromise associated with _deferred for return to JS
   */
  Napi::Promise GetPromise() { return m_deferred.Promise(); }

 protected:
  void Execute() {
    CLIPSValue cv;
    EvalError err = Eval(*_clips_env, content.c_str() ,&cv);
    switch (err)
    {
    case EE_PARSING_ERROR:
      error = string("Parsing Error");
      break;

    case EE_PROCESSING_ERROR:
      error = string("Processing Error");
      break;
    
    default:
      error = string("noerror");
      result = string(cv.lexemeValue->contents);
      break;
    }
  }
  void OnOK() { 
    if(strcmp(error.c_str(),"noerror")!=0)
      m_deferred.Reject(Napi::String::New(Env(),error));
    else
      m_deferred.Resolve(Napi::String::New(Env(), result)); 
  
  }
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment **_clips_env;
  string result;
  string error;
  string content;
};

#endif
