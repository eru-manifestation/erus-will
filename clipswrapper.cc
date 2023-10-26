#include "clipswrapper.h"
#include "clips/clips.h"
#include <string.h>
#include <iostream>

using namespace std;

// string getDebugBuffer(Environment *env){
//   CLIPSValue cv;
//   Eval(env, "?*debug*",&cv);
//   string res = cv.lexemeValue->contents;
//   Eval(env, "(bind ?*debug* \"\")",NULL);
//   return res;
// }
// string getObtainBuffer(Environment *env){
//   CLIPSValue cv;
//   Eval(env, "?*obtain*",&cv);
//   string res = cv.lexemeValue->contents;
//   Eval(env, "(bind ?*obtain* \"\")",NULL);
//   return res;
// }
// string getAnnounceBuffer(Environment *env){
//   CLIPSValue cv;
//   Eval(env, "?*announce*",&cv);
//   string res = cv.lexemeValue->contents;
//   Eval(env, "(bind ?*announce* \"\")",NULL);
//   return res;
// }


// #define DRIBBLE_DATA USER_ENVIRONMENT_DATA + 0
// struct dribbleData
// {
//   char *announce;
// };

// //#define DribbleData(theEnv) \ ((struct dribbleData *) GetEnvironmentData(theEnv,DRIBBLE_DATA))

// bool QueryAnnounceCallback(Environment *,const char *,void *);
// void WriteAnnounceCallback(Environment *,const char *,const char *,void *);

// bool QueryAnnounceCallback(
//   Environment *environment,
//   const char *logicalName,
//   void *context)
// {
//   if (strcmp(logicalName,"announce") == 0) return(true);
//   return(false);
// }

// void WriteAnnounceCallback(
//   Environment *environment,
//   const char *logicalName,
//   const char *str,
//   void *context)
// {
//   //Adds the string to the local variable
//   printf(str);
// }


Napi::Object ClipsWrapper::Init(Napi::Env env, Napi::Object exports) {
  Napi::Function func =
      DefineClass(env,
                  "ClipsWrapper",
                  {InstanceMethod("getFacts", &ClipsWrapper::GetFacts),
                    InstanceMethod("getDebugBuffer", &ClipsWrapper::GetDebugBuffer),
                    InstanceMethod("getAnnounceBuffer", &ClipsWrapper::GetAnnounceBuffer),
                    InstanceMethod("getObtainBuffer", &ClipsWrapper::GetObtainBuffer)});

  Napi::FunctionReference* constructor = new Napi::FunctionReference();
  *constructor = Napi::Persistent(func);
  env.SetInstanceData(constructor);

  exports.Set("ClipsWrapper", func);
  return exports;
}

ClipsWrapper::ClipsWrapper(const Napi::CallbackInfo& info)
    : Napi::ObjectWrap<ClipsWrapper>(info) {
  Napi::Env env = info.Env();


  this->clips_env_ = CreateEnvironment();
  printf("salida\n");
  // AddRouter(this->clips_env_,
  //   "announce", /* Router name */
  //   50, /* Priority */
  //   QueryAnnounceCallback, /* Query function */
  //   WriteAnnounceCallback, /* Write function */
  //   NULL, /* Read function */
  //   NULL, /* Unread function */
  //   NULL, /* Exit function */
  //   NULL); /* Context */

  Load(this->clips_env_, "C:\\Users\\Pablo\\Documents\\GitHub\\erus-will\\load.clp");
  Eval(this->clips_env_, "(load-all)", NULL);
  Run(this->clips_env_, -1);

  //cout<<getDebugBuffer(this->clips_env_);
  cout<<"Enviroment created\n";
  //cout<<getAnnounceBuffer(this->clips_env_);
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
  //TODO: Añadir string como hecho a base de hechos
  //AssertString(this->clips_env_, "(colores rojo azul amarillo)");
  //return Napi::String::New(info.Env(), "Fact asserted ...");

  CLIPSValue cv;
  Eval(this->clips_env_, "?*announce*",&cv);
  string res = cv.lexemeValue->contents;
  Eval(this->clips_env_, "(bind ?*announce* \"\")",NULL);
  return Napi::String::New(info.Env(), res);
}

Napi::Value ClipsWrapper::GetDebugBuffer(const Napi::CallbackInfo& info) {
  CLIPSValue cv;
  Eval(this->clips_env_, "?*debug*",&cv);
  string res = cv.lexemeValue->contents;
  Eval(this->clips_env_, "(bind ?*debug* \"\")",NULL);
  return Napi::String::New(info.Env(), res);
}

Napi::Value ClipsWrapper::GetObtainBuffer(const Napi::CallbackInfo& info) {
  CLIPSValue cv;
  Eval(this->clips_env_, "?*obtain*",&cv);
  string res = cv.lexemeValue->contents;
  Eval(this->clips_env_, "(bind ?*obtain* \"\")",NULL);
  return Napi::String::New(info.Env(), res);
}
