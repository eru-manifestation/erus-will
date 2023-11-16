#include <napi.h>
#include "clipswrapper.h"

Napi::Object InitAll(Napi::Env env, Napi::Object exports) {
  return ClipsWrapper::Init(env, exports);
}

NODE_API_MODULE(addon, InitAll)
