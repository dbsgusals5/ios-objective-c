//
//  NumberInputTextField.m
//  NumberInputView
//
//  Created by Foresight System TADA Tetsuya on 2014/09/09.
//  Copyright (c) 2014年 Fujitsu. All rights reserved.
//

#import "NumberInputTextField.h"
#import "UITextField+NumberInputView.h"

@interface NumberInputTextField ()
@end

@implementation NumberInputTextField

/**
 @brief フレーム初期処理
 @details 初期セットアップを実行する。
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self inputViewInitialize];
    }
    return self;
}

/**
 @brief 初期化処理
 @details 初期セットアップを実行する。
 */
- (void)awakeFromNib {
    [self inputViewInitialize];
}

/**
 @brief 初期設定
 */
- (void)inputViewInitialize {
    // テンキーパッドViewの定義
    NumberInputView *inputView = [NumberInputView new];
    inputView.delegate = self;
    // TextFieldのInputViewにテンキーパッドを設定
    self.inputView = inputView;
    
    // イベントの定義
    [self addTarget:self action:@selector(numberInputTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(numberInputTextFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - UITextField

- (void)numberInputTextFieldDidChange {
    if (![self.text length]) return;
}

- (void)numberInputTextFieldDidEndEditing {
}


#pragma mark - NumberInputViewDelegate

/**
 @brief キータップ時処理
 */
- (void)numberInputView:(NumberInputView *)inputView didTapKey:(NSString *)key {
    if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        NSRange range = [self selectedNSRange];
        if ([self.delegate textField:self shouldChangeCharactersInRange:range replacementString:key]) {
            [self insertText:key];
        }
    } else {
        [self insertText:key];
    }
}

/**
 @brief クローズキー タップ時処理
 @details キーボードを閉じる。
 */
- (void)numberInputViewDidTapClose:(NumberInputView *)inputView {
    [self resignFirstResponder];
}

/**
 @brief バックスペースキー タップ時処理
 @details TextFieldにバックワードを送る
 */
- (void)numberInputViewDidTapBackspace:(NumberInputView *)calculatorInputView {
    [self deleteBackward];
}

/**
 @brief バックスペースキー ロングタップ時処理
 @details 入力値をクリアする。
 */
- (void)numberInputViewDidLongTapBackspace:(NumberInputView *)calculatorInputView {
    [self setText:nil];
}

@end
