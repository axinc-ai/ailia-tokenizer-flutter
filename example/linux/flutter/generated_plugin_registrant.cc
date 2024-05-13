//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <ailia_tokenizer/ailia_tokenizer_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) ailia_tokenizer_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AiliaTokenizerPlugin");
  ailia_tokenizer_plugin_register_with_registrar(ailia_tokenizer_registrar);
}
