//
//  KerningTextFiled.m
//  HousingOmu
//
//  Created by Alpha on 2019/04/01.
//  Copyright © 2019年 alpha. All rights reserved.
//

#import "KerningTextFiled.h"

@interface KerningTextFiled ()

@end

@implementation KerningTextFiled

/**
 * @brief コントロールの初期化クラス
 */
- (void)awakeFromNib
{
    // 基底のメソッドで初期化
    [super awakeFromNib];

    // 文字間を開けて描画
    [self drawKerningText];
    [self drawKerningPlaceholder];
}

/**
 * @brief 規定の描画クラス
 */
- (void)drawRect:(CGRect)rect
{
    // 文字間を開けて描画
    [self drawKerningText];
    [self drawKerningPlaceholder];

    // 親Viewより外を描画しない
    self.clipsToBounds = YES;
    
    // 基底のメソッドで描画
    [super drawRect:rect];
}

/**
 * @brief 文字間テキストフィールドの描画
 */
- (void)drawKerningText
{
    NSString *string = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    // テキストのスタイルにカーニング(文字間隔)を設定
    [attributedString addAttribute:NSKernAttributeName
                             value:@(self.letterSpacing)
                             range:NSMakeRange(0, [string length])];
    self.attributedText = attributedString;
}

/**
 * @brief 文字間プレースホルダの描画
 */
- (void)drawKerningPlaceholder
{
    NSString *string = self.placeholder;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    // プレースホルダ(何も入力されていない状態で表示する文言)のスタイルにカーニング(文字間隔)を設定
    [attributedString addAttribute:NSKernAttributeName
                             value:@(self.letterSpacing)
                             range:NSMakeRange(0, [string length])];
    self.attributedPlaceholder = attributedString;
}

@end
