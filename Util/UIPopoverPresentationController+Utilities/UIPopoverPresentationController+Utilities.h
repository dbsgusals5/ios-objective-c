//
//  UIPopoverPresentationController+Utilities.h
//
//  Created by alpha on 2016/11/01.
//  Copyright © 2016年 Kamide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPopoverPresentationController (Utilities) <UIPopoverPresentationControllerDelegate>

+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                                 targetBounds:(CGRect)targetBounds
                                     permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                         parentViewController:(UIViewController *)parentViewController
                                                     animated:(BOOL)animated;

+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                     permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                         parentViewController:(UIViewController *)parentViewController
                                                     animated:(BOOL)animated;

+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                     permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                         parentViewController:(UIViewController *)parentViewController;

+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                         parentViewController:(UIViewController *)parentViewController;

- (void)dismissPopoverAnimated:(BOOL)animated;

// 枠線を追加
- (void)setFrameBorder;
- (void)setFrameBorderWithBorderColor:(UIColor *)borderColor;
- (void)setFrameBorderWithBorderWidth:(CGFloat)borderWidth;
- (void)setFrameBorderWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

// ポップオーバー外をタップした際にポップオーバーを消すか否かを設定する
- (void)setPopoverPresentationControllerShouldDismissPopover:(BOOL)flg;

@end

/*------------------------------------------------------------------------------------------------------------------------------------------
 ポップオーバーの影を設定するカテゴリクラス
 -----------------------------------------------------------------------------------------------------------------------------------------*/
@interface UIPopoverBackgroundView (shadow)

@end

/*---------------------------------------------------------------------------------------------------
 ポップオーバーの吹き出し含む背景を消すためのクラス
 ---------------------------------------------------------------------------------------------------*/
@interface NoBalloonPopoverBackgroundView : UIPopoverBackgroundView

@end
