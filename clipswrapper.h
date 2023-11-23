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
  Napi::Value GetFacts(const Napi::CallbackInfo& info);
  Napi::Value GetDebugBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetAnnounceBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetChooseBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetStateBuffer(const Napi::CallbackInfo& info);
  Napi::Value WrapDestroyEnvironment(const Napi::CallbackInfo& info);
  Napi::Value WrapEval(const Napi::CallbackInfo& info);

  Environment *clips_env_;
};

#include <iostream>

class CreateEnvironmentWorker : public Napi::AsyncWorker {
 public:
  CreateEnvironmentWorker(const Napi::Env& env, Environment** clipsEnv)
      : Napi::AsyncWorker{env, "CreateEnvironmentWorker"},
        m_deferred{env},
        clipsEnv{clipsEnv} {
          //SuppressDestruct();
        }

  /**
   * GetPromise associated with _deferred for return to JS
   */
  Napi::Promise GetPromise() { return m_deferred.Promise(); }

 protected:
  /**
   * Simulate heavy math work
   */
  void Execute() {
    *clipsEnv = CreateEnvironment();
    Load(*clipsEnv, "load.clp");
    Eval(*clipsEnv, "(load-all)", NULL);
    Run(*clipsEnv, -1);
    result = string("Environment created");
  }

  /**
   * Resolve the promise with the result
   */
  void OnOK() { m_deferred.Resolve(Napi::String::New(Env(), result)); }

  /**
   * Reject the promise with errors
   */
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment **clipsEnv;
  string result;
};

#endif
