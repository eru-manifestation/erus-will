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
  Napi::Value GetFacts(const Napi::CallbackInfo& info);
  Napi::Value GetDebugBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetAnnounceBuffer(const Napi::CallbackInfo& info);
  Napi::Value GetObtainBuffer(const Napi::CallbackInfo& info);
  Napi::Value WrapDestroyEnvironment(const Napi::CallbackInfo& info);
  Napi::Value WrapEval(const Napi::CallbackInfo& info);

  Environment *clips_env_;
};

#endif
