{
  "targets": [
    {
      "target_name": "addon",
      "sources": [ "addon.cc", "clipswrapper.h", "clipswrapper.cc", "<!@(node -p \"require('fs').readdirSync('./clips').map(f=>'clips/'+f).join(' ')\")"],
      "include_dirs": [
        "<!@(node -p \"require('node-addon-api').include\")"
      ],
      'defines': [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ],
    }
  ]
}
