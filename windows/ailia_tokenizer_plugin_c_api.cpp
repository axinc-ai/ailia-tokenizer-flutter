#include "include/ailia_tokenizer/ailia_tokenizer_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ailia_tokenizer_plugin.h"

void AiliaTokenizerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ailia_tokenizer::AiliaTokenizerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
