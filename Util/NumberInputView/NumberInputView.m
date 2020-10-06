//
//  NumberInputView.m
//  NumberInputView
//
//  Created by Foresight System TADA Tetsuya on 2014/09/09.
//  Copyright (c) 2014年 Fujitsu. All rights reserved.
//

#import "NumberInputView.h"

@interface NumberInputView ()

/// 数字キーコレクション
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numberButtonCollection;
/// 制御キーコレクション
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *operationButtonCollection;

@end

@implementation NumberInputView

/**
 @brief フレーム初期処理
 @details 
 - ボタン初期カラーを設定する。
 - バックスペースキーロングタップジェスチャーを設定する。
 */
- (id)initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"NumberInputView" owner:self options:nil] firstObject];
    if (self) {
        // ボタン初期カラーを設定
        [self setNumberButtonBackgroundColor:[UIColor clearColor]];
        [self setOperationButtonBackgroundColor:[UIColor clearColor]];
        [self setButtonTitleColor:[UIColor darkTextColor]];

//        for (UIButton *numberButton in self.numberButtonCollection) {
//            [self setupButton:numberButton];
//        }
//        for (UIButton *operationButton in self.operationButtonCollection) {
//            [self setupButton:operationButton];
//        }
        // バックスペースキーロングタップジェスチャー
        UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressKeyBack:)];
        longPressGesture.minimumPressDuration = 0.5f;
        [_backspaceKey addGestureRecognizer:longPressGesture];
    }
    return self;
}

/**
 @brief ボタン共通初期化処理
 @note 現在未使用。
 */
- (void)setupButton:(UIButton *)button {
//    button.layer.borderWidth = 0.25f;
}

/**
 @brief バックスペースキー タップ時処理
 @details デリゲートメソッドをコールする。
 @param sender 対象のボタン
 */
- (IBAction)userDidTapBackspace:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(numberInputViewDidTapBackspace:)]) {
        [self.delegate numberInputViewDidTapBackspace:self];
    }
}

/**
 @brief クローズキー タップ時処理
 @details デリゲートメソッドをコールする。
 @param sender 対象のボタン
 */
- (IBAction)userDidTapClose:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(numberInputViewDidTapClose:)]) {
        [self.delegate numberInputViewDidTapClose:self];
    }
}

/**
 @brief (数字)キー タップ時処理
 @details デリゲートメソッドをコールする。
 @param sender 対象のボタン
 */
- (IBAction)userDidTapKey:(UIButton *)sender {
    [[UIDevice currentDevice] playInputClick];
    if ([self.delegate respondsToSelector:@selector(numberInputView:didTapKey:)]) {
        [self.delegate numberInputView:self didTapKey:sender.titleLabel.text];
    }
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

#pragma mark - Properties

/**
 @brief タイトルカラー セッター
 @param buttonTitleColor セットする色
 */
- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        [numberButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        [operationButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    }
}

/**
 @brief タイトルフォント セッター
 @param buttonTitleFont セットするフォント
 */
- (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.titleLabel.font = buttonTitleFont;
    }
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.titleLabel.font = buttonTitleFont;
    }
}

/**
 @brief 数字キー背景色 セッター
 @note 定義はできるが、基本的に使用しない(画像を貼り付けている)。
 @param numberButtonBackgroundColor セットする色
 */
- (void)setNumberButtonBackgroundColor:(UIColor *)numberButtonBackgroundColor {
    _numberButtonBackgroundColor = numberButtonBackgroundColor;
    for (UIButton *numberButton in self.numberButtonCollection) {
        numberButton.backgroundColor = numberButtonBackgroundColor;
    }
}

/**
 @brief 制御キー背景色 セッター
 @note 定義はできるが、基本的に使用しない(画像を貼り付けている)。
 @param operationButtonBackgroundColor セットする色
 */
- (void)setOperationButtonBackgroundColor:(UIColor *)operationButtonBackgroundColor {
    _operationButtonBackgroundColor = operationButtonBackgroundColor;
    for (UIButton *operationButton in self.operationButtonCollection) {
        operationButton.backgroundColor = operationButtonBackgroundColor;
    }
}

#pragma mark - Method
/**
 @brief バックスペースキー ロングタップ処理
 @details バックスペースキーをロングタップした際に呼ばれる。デリゲートメソッドをコールする。
 @param sender ロングタップジェスチャー
 */
- (void)pressKeyBack:(UILongPressGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            //長押しを検知開始
            NSLog(@"began");
        {
            if ([self.delegate respondsToSelector:@selector(numberInputViewDidLongTapBackspace:)]) {
                [self.delegate numberInputViewDidLongTapBackspace:self];
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
            //長押し終了時
            break;
            
        default:
            break;
    }
}
@end
