//
//  KerningLabel.m
//  Housing_Shibata
//
//  Created by Alpha on 2019/04/01.
//  Copyright © 2019年 alpha. All rights reserved.
//

#import "KerningLabel.h"

@interface KerningLabel ()

@property (nonatomic) NSDictionary *saveAttributedText;

@end

@implementation KerningLabel

/**
* @brief コントロールの初期化クラス
*/
- (void)awakeFromNib
{
    // 基底のメソッドで初期化
    [super awakeFromNib];
    
    // 初期化時に元々設定されているスタイルを取得
    self.saveAttributedText = [self.attributedText attributesAtIndex:0 effectiveRange:nil];

    // 文字間を開けて描画
    [self drawKerningLabel];
}

/**
 * @brief 規定の描画クラス
 */
- (void)drawRect:(CGRect)rect
{
    // 文字間を開けて描画
    [self drawKerningLabel];
    
    // 親Viewより外を描画しない
    self.clipsToBounds = YES;
    
    // 基底のメソッドで描画
    [super drawRect:rect];
}

/**
 * @brief 文字間ラベルの描画
 */
- (void)drawKerningLabel
{
    NSString *string;
    NSMutableAttributedString *attributed;

    // 元のスタイルにカーニング(文字間隔)を追加
    string = self.text;
    attributed = [[NSMutableAttributedString alloc] initWithString:string
                                                        attributes:self.saveAttributedText];
    [attributed addAttribute:NSKernAttributeName
                       value:@(self.letterSpacing)
                       range:NSMakeRange(0, [string length])];
    self.attributedText = attributed;
}

@end
