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
  Napi::Value GetDebugBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetAnnounceBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetChooseBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetStateBuffer(const Napi::CallbackInfo& info);
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
    string command1 = "(get-content " + content + ")";
    string command2 = "(bind " + content + " (create$))";
    Eval(*_clips_env, command1.c_str() ,&cv);
    result = string(cv.lexemeValue->contents);
    Eval(*_clips_env, command2.c_str() ,NULL);
  }
  void OnOK() { m_deferred.Resolve(Napi::String::New(Env(), result)); }
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment **_clips_env;
  string result;
  string content;
};


class GetStateWorker : public Napi::AsyncWorker {
 public:
  GetStateWorker(const Napi::Env& env, Environment** _clips_env, string player, string content)
      : Napi::AsyncWorker{env, "GetStateWorker"},
        m_deferred{env},
        _clips_env{_clips_env},
        player{player},
        content{content} {}

  /**
   * GetPromise associated with _deferred for return to JS
   */
  Napi::Promise GetPromise() { return m_deferred.Promise(); }

 protected:
  void Execute() {
    string command0 = "(update-index (symbol-to-instance-name "+player+"))";
    string command1 = "(get-content " + content + ")";
    string command2 = "(bind " + content + " (create$))";

    CLIPSValue cv;
    Eval(*_clips_env, command0.c_str() ,NULL);
    Eval(*_clips_env, command1.c_str() ,&cv);
    Eval(*_clips_env, command2.c_str() ,NULL);
    result = string(cv.lexemeValue->contents);
  }
  void OnOK() { m_deferred.Resolve(Napi::String::New(Env(), result)); }
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment **_clips_env;
  string result;
  string content;
  string player;
};


class WrapEvalWorker : public Napi::AsyncWorker {
 public:
  WrapEvalWorker(const Napi::Env& env, Environment** _clips_env, string orders)
      : Napi::AsyncWorker{env, "WrapEvalWorker"},
        m_deferred{env},
        _clips_env{_clips_env},
        orders{orders} {}

  /**
   * GetPromise associated with _deferred for return to JS
   */
  Napi::Promise GetPromise() { return m_deferred.Promise(); }

 protected:
  void Execute() {
    CLIPSValue cv;
    Eval(*_clips_env, orders.c_str() ,&cv);
    switch(cv.header->type){
      case STRING_TYPE:
      case SYMBOL_TYPE:
        result = Napi::String::New(Env(), cv.lexemeValue->contents);
        break;
      case FLOAT_TYPE:
        result = Napi::Number::New(Env(), cv.floatValue->contents);
        break;
      case INTEGER_TYPE:
        result = Napi::Number::New(Env(), cv.integerValue->contents);
        break;
      default:
        result = Napi::Boolean::New(Env(), true);
        break;
    }
  }
  void OnOK() { m_deferred.Resolve(result); }
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment **_clips_env;
  Napi::Value result;
  string orders;
};

#endif
