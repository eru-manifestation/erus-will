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
  Environment *clips_env_;
  string *result;

 private:
  Napi::Value PromiseCreateEnvironment(const Napi::CallbackInfo& info);
  Napi::Value GetFacts(const Napi::CallbackInfo& info);
  Napi::Value GetDebugBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetAnnounceBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetChooseBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetStateBuffer(const Napi::CallbackInfo& info);
  Napi::Value WrapDestroyEnvironment(const Napi::CallbackInfo& info);
  Napi::Value WrapEval(const Napi::CallbackInfo& info);

};

#include <iostream>

class CreateEnvironmentWorker : public Napi::AsyncWorker {
 public:
  CreateEnvironmentWorker(const Napi::Env& env, Environment* clipsEnv, string* result)
      : Napi::AsyncWorker{env, "CreateEnvironmentWorker"},
        m_deferred{env},
        clipsEnv{clipsEnv},
        result{result} {
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
    
    cout << "Pointer al entrar la llamada\t";
    cout << clipsEnv;
    cout << endl;
    cout << "Result al entrar la llamada\t";
    cout << *result;
    cout << endl;

    string command1 = "(get-content ?*announce-p1*)";
    CLIPSValue cv;
    Eval(clipsEnv, command1.c_str() ,&cv);
    cout << cv.lexemeValue->contents;
    cout << endl;

    

    *result = string("Environment created");
    cout << "Pointer justo despues\t";
    cout << clipsEnv;
    cout << endl;
    cout << "Result justo despues\t";
    cout << *result;
    cout << endl;
  }

  /**
   * Resolve the promise with the result
   */
  void OnOK() { m_deferred.Resolve(Napi::String::New(Env(), *result)); }

  /**
   * Reject the promise with errors
   */
  void OnError(const Napi::Error& err) { m_deferred.Reject(err.Value()); }

 private:
  Napi::Promise::Deferred m_deferred;
  Environment *clipsEnv;
  string* result;
};

#endif
