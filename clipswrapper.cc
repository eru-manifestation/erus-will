#include "clipswrapper.h"
#include "clips/clips.h"
#include <string.h>

char* getDebugBuffer(Environment *env, char* res){
  CLIPSValue cv;
  Eval(env, "?*debug*",&cv);
  strcpy(res, cv.lexemeValue->contents);
  Eval(env, "(bind ?*debug* \"\")",NULL);
  return res;
}
char* getObtainBuffer(Environment *env, char* res){
  CLIPSValue cv;
  Eval(env, "?*obtain*",&cv);
  strcpy(res, cv.lexemeValue->contents);
  Eval(env, "(bind ?*obtain* \"\")",NULL);
  return res;
}
char* getAnnounceBuffer(Environment *env, char* res){
  CLIPSValue cv;
  Eval(env, "?*announce*",&cv);
  strcpy(res, cv.lexemeValue->contents);
  Eval(env, "(bind ?*announce* \"\")",NULL);
  return res;
}


Napi::Object ClipsWrapper::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function func =
      DefineClass(env,
                  "ClipsWrapper",
                  {InstanceMethod("getFacts", &ClipsWrapper::GetFacts),
                   InstanceMethod("assertString", &ClipsWrapper::Assert)});

  Napi::FunctionReference* constructor = new Napi::FunctionReference();
  *constructor = Napi::Persistent(func);
  env.SetInstanceData(constructor);

  exports.Set("ClipsWrapper", func);
  return exports;
}

ClipsWrapper::ClipsWrapper(const Napi::CallbackInfo& info)
    : Napi::ObjectWrap<ClipsWrapper>(info) {
  Napi::Env env = info.Env();

  //Environment *clips_env_;

  this->clips_env_ = CreateEnvironment();
  printf("salida\n");

  Load(this->clips_env_, "C:\\Users\\Pablo\\Documents\\GitHub\\erus-will\\load.clp");
  Eval(this->clips_env_, "(load-all)", NULL);
  Run(this->clips_env_, -1);

  char res[200000] = "";
  getDebugBuffer(this->clips_env_, res);
  printf("Debug buffer:\n%s\n\n",res);
  getAnnounceBuffer(this->clips_env_, res);
  printf("Announce buffer:\n%s\n\n",res);
}

Napi::Value ClipsWrapper::GetFacts(const Napi::CallbackInfo& info) {
  //String num = this->CLIPSenv;
  //TODO: Devolver hechos
  CLIPSValue cv;
  // Eval(this->clips_env_, "(do-for-)")
  Eval(this->clips_env_,"(sym-cat (random 0 99))",&cv);
  return Napi::String::New(info.Env(), cv.lexemeValue->contents);
}

Napi::Value ClipsWrapper::Assert(const Napi::CallbackInfo& info) {
  //TODO: Añadir string como hecho a base de hechos
  AssertString(this->clips_env_, "(colores rojo azul amarillo)");
  return Napi::String::New(info.Env(), "Fact asserted ...");
}
