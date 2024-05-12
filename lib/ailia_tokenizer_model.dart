// ailia Tokenizer Utility Class

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:ailia_insight/ffi/ailia_tokenizer.dart' as ailia_tokenizer_dart;

class AiliaTokenizerModel {
  dynamic ailiaTokenizer;
  Pointer<Pointer<ailia_tokenizer_dart.AILIATokenizer>>? ppAiliaTokenizer;
  bool available = false;

  final int ailiaStatusSuccess = 0;

  static String ailiaCommonGetTokenizerPath() {
    if (Platform.isAndroid || Platform.isLinux) {
      return 'libailia_tokenizer.so';
    }
    if (Platform.isMacOS) {
      return 'libailia_tokenizer.dylib';
    }
    if (Platform.isWindows) {
      return 'ailia_tokenizer.dll';
    }
    return 'internal';
  }

  static DynamicLibrary ailiaCommonGetLibrary(String path) {
    final DynamicLibrary library;
    if (Platform.isIOS) {
      library = DynamicLibrary.process();
    } else {
      library = DynamicLibrary.open(path);
    }
    return library;
  }

  void openFile(
    int tokenizerType, {
    String? modelFile,
    String? vocabFile,
    String? mergeFile,
  }) {
    close(); // for reopen

    ailiaTokenizer = ailia_tokenizer_dart.ailiaTokenizerFFI(
      ailiaCommonGetLibrary(ailiaCommonGetTokenizerPath()),
    );
    ppAiliaTokenizer = malloc<Pointer<ailia_tokenizer_dart.AILIATokenizer>>();

    int status = ailiaStatusSuccess;

    status = ailiaTokenizer.ailiaTokenizerCreate(
      ppAiliaTokenizer,
      tokenizerType,
      ailia_tokenizer_dart.AILIA_TOKENIZER_FLAG_NONE,
    );
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaTokenizerCreate error $status");
    }

    if (modelFile != null) {
      if (Platform.isWindows) {
        status = ailiaTokenizer.ailiaTokenizerOpenModelFileW(
          ppAiliaTokenizer!.value,
          modelFile.toNativeUtf16().cast<Int16>(),
        );
      } else {
        status = ailiaTokenizer.ailiaTokenizerOpenModelFileA(
          ppAiliaTokenizer!.value,
          modelFile.toNativeUtf8().cast<Int8>(),
        );
      }
      if (status != ailiaStatusSuccess) {
        throw Exception("ailiaTokenizerOpenModelFileA error $status");
      }
    }

    if (vocabFile != null) {
      if (Platform.isWindows) {
        status = ailiaTokenizer.ailiaTokenizerOpenVocabFileW(
          ppAiliaTokenizer!.value,
          vocabFile.toNativeUtf16().cast<Int16>(),
        );
      } else {
        status = ailiaTokenizer.ailiaTokenizerOpenVocabFileA(
          ppAiliaTokenizer!.value,
          vocabFile.toNativeUtf8().cast<Int8>(),
        );
      }
      if (status != ailiaStatusSuccess) {
        throw Exception(
            "ailiaTokenizerOpenVocabFile error $status : $vocabFile");
      }
    }

    if (mergeFile != null) {
      if (Platform.isWindows) {
        status = ailiaTokenizer.ailiaTokenizerOpenMergeFileW(
          ppAiliaTokenizer!.value,
          mergeFile.toNativeUtf16().cast<Int16>(),
        );
      } else {
        status = ailiaTokenizer.ailiaTokenizerOpenMergeFileA(
          ppAiliaTokenizer!.value,
          mergeFile.toNativeUtf8().cast<Int8>(),
        );
      }
      if (status != ailiaStatusSuccess) {
        throw Exception(
            "ailiaTokenizerOpenMergeFile error $status : $mergeFile");
      }
    }

    available = true;
  }

  void close() {
    if (!available) {
      return;
    }

    Pointer<ailia_tokenizer_dart.AILIATokenizer> tokenizer =
        ppAiliaTokenizer!.value;
    ailiaTokenizer.ailiaTokenizerDestroy(tokenizer);
    malloc.free(ppAiliaTokenizer!);

    available = false;
  }

  Int32List encode(String text) {
    int status;

    if (!available) {
      throw Exception("Model not opened");
    }

    status = ailiaTokenizer.ailiaTokenizerEncode(
      ppAiliaTokenizer!.value,
      text.toNativeUtf8().cast<Int8>(),
    );
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaTokenizerEncode error $status");
    }

    final Pointer<Uint32> count = malloc<Uint32>();
    count.value = 0;
    status = ailiaTokenizer.ailiaTokenizerGetTokenCount(
      ppAiliaTokenizer!.value,
      count,
    );
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaTokenizerGetTokenCount error $status");
    }

    Pointer<Int32> tokens = malloc<Int32>(count.value);
    status = ailiaTokenizer.ailiaTokenizerGetTokens(
      ppAiliaTokenizer!.value,
      tokens,
      count.value,
    );
    if (status != ailiaStatusSuccess) {
      throw Exception("ailiaTokenizerGetTokens error $status");
    }

    Int32List tokensF = Int32List(count.value);
    for (int i = 0; i < count.value; i++) {
      tokensF[i] = tokens[i];
    }

    malloc.free(tokens);
    malloc.free(count);

    return tokensF;
  }
}
