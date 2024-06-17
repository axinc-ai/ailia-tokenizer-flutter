//
//  AiliaTokenizerPluginPreventStrip.c
//
//  Created by Kazuki Kyakuno on 2023/07/31.
//

// Dummy link to keep libailia_tokenizer.a from being deleted

extern int ailiaTokenizerCreate(void** net, int type, int flags);

void test(void){
    ailiaTokenizerCreate(0, 0, 0);
}
