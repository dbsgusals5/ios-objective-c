//
//  KerningLabel.h
//  Housing_Shibata
//
//  Created by Alpha on 2019/04/01.
//  Copyright © 2019年 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KerningLabel : UILabel

// IBInspectableをしていることでStoryboardからも設定できるようになる
@property (nonatomic) IBInspectable CGFloat letterSpacing;

@end
