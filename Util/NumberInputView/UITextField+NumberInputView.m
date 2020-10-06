//
//  UITextField+NumberInputView.m
//  NumberInputView
//
//  Created by Foresight System TADA Tetsuya on 2014/09/09.
//  Copyright (c) 2014年 Fujitsu. All rights reserved.
//

#import "UITextField+NumberInputView.h"

@implementation UITextField (NumberInputView)

/**
 @brief TextField 選択箇所Range取得
 @return 開始位置と長さ
 */
- (NSRange)selectedNSRange
{
    // ドキュメントの先頭のUITextPositionを保持
    UITextPosition *beginning = self.beginningOfDocument;
    // 現在選択されているテキスト範囲をUITextRangeで保持
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;   // 開始
    UITextPosition *selectionEnd = selectedRange.end;       // 終了
    
    // 開始位置と長さを取得して戻す
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

@end
