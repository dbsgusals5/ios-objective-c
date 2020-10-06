//
//  NumberInputView.h
//  NumberInputView
//
//  Created by Foresight System TADA Tetsuya on 2014/09/09.
//  Copyright (c) 2014年 Fujitsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberInputView;
@protocol NumberInputViewDelegate <NSObject>

// デリゲート種類
@optional
/// (数字)キー タップ時処理
- (void)numberInputView:(NumberInputView *)inputView didTapKey:(NSString *)key;
/// クローズキー タップ時処理
- (void)numberInputViewDidTapClose:(NumberInputView *)inputView;
/// バックスペースキー タップ時処理
- (void)numberInputViewDidTapBackspace:(NumberInputView *)inputView;
/// バックスペースキー ロングタップ時処理
- (void)numberInputViewDidLongTapBackspace:(NumberInputView *)inputView;
@end

/**
 @mainpage
 
 @section 概要
 カスタムソフトウェアキーボード「NumberInputView」。iPad専用のテンキーパッドである。
 
 @section 詳細解説
 
 @subsection 利用方法
 - 1. 使用したいプロジェクトに「NumberInputView」のフォルダごと導入する。
 - 2. テンキーパッドを使うUITextFieldのクラスをNumberInputTextField」にする。
 
 @subsection モジュールの更新について
 改変は開発用プロジェクト「NumberInputViewDev」にて行うこととする。\n
 そのプロジェクトで更新したものを正規とし、個別に変更した時点で別物の扱いとする。
 
 @section バージョン履歴
 日付は、完成を現してる。\n
 「NumberInputViewDev」にも同様の記載をしている。
 
 @version 1.0.0 (2014/9/9)
 - 1. 数字・バックスペース・キーボードクローズキーを実装。
 - 2. 端末の向きに合わせて大きさを変える対応。
 */

/**
 @brief テンキーパッド
 @details 数字入力に特化したキーボード。InputViewとして利用する。
 */
@interface NumberInputView : UIView <UIInputViewAudioFeedback>

/// デリゲート
@property (weak, nonatomic) id<NumberInputViewDelegate> delegate;
/// バックスペースキー
@property (weak, nonatomic) IBOutlet UIButton *backspaceKey;

/// ボタン表題カラー
@property (strong, nonatomic) UIColor *buttonTitleColor;
/// ボタン表題フォント
@property (strong, nonatomic) UIFont  *buttonTitleFont;

/// 以下、現在未使用
@property (strong, nonatomic) UIColor *numberButtonBackgroundColor;
@property (strong, nonatomic) UIColor *operationButtonBackgroundColor;

@end
