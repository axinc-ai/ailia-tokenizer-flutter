Please put libraries here by using release script.

ailia/android/src/main/jniLibs/arm64-v8a/libailia_tokenizer.so
ailia/ios/libailia_tokenizer.a
ailia/macos/libailia_tokenizer.dylib

Please put interface here.

native/ailia.h
native/ailia_tokenizer.h
native/ailia_call.h

Add stddef.h to ailia.h

#include <stddef.h>

Please run below command for generation.

dart run ffigen --config ffigen_ailia_tokenizer.yaml

or

/Users/kyakuno/flutter_x86_64_3221/bin/dart run ffigen --config ffigen_ailia_tokenizer.yaml
