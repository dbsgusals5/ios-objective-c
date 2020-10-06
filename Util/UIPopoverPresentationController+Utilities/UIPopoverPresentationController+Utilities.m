//
//  UIPopoverPresentationController+Utilities.m
//
//  Created by alpha on 2016/11/01.
//  Copyright © 2016年 Kamide. All rights reserved.
//

#import "UIPopoverPresentationController+Utilities.h"


@implementation UIPopoverPresentationController (Utilities)

static const CGFloat defaultBorderWidth  = 2.0f;
static const CGFloat defaultBorderRadius = 10.0f;
+ (UIColor *)defaultBorderColor {
    return [UIColor colorWithRed:0.098f green:0.098f blue:0.439f alpha:1.0f];
}

BOOL popoverPresentationControllerShouldDismissPopover = YES;

/**
 @brief ポップオーバーの表示（svc, inView, arrowDirections, parentViewController, animated）
 @param	svc (UIViewController *)                    ポップオーバーに表示するviewController
 @param	inView (UIView *)                           吹き出しを当てるview
 @param	targetBounds (CGRect)						ポップオーバーを出す位置（通常はinViewのBounds）
 @param arrowDirections (UIPopoverArrowDirection)   吹き出しの方向
 @param parentViewController (UIViewController *)   ポップオーバーの親になるview（通常はself）
 @param animated (BOOL)                             アニメーションのON/OFF
 @return UIPopoverPresentationController
 */
+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                                 targetBounds:(CGRect)targetBounds
                                     permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                         parentViewController:(UIViewController *)parentViewController
                                                     animated:(BOOL)animated
{
    svc.modalPresentationStyle = UIModalPresentationPopover;
    svc.preferredContentSize = svc.view.frame.size;
    
    UIPopoverPresentationController *presentationController = svc.popoverPresentationController;
    presentationController.sourceView = inView;
    presentationController.delegate = presentationController;
    
    if (arrowDirections == UIPopoverArrowDirectionUnknown) {
        
        presentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
        presentationController.popoverBackgroundViewClass = [NoBalloonPopoverBackgroundView class];
        
        // ポップオーバーの位置を画面中央にする
        CGRect inViewRect = [inView convertRect:inView.bounds toView:nil];
        CGRect screenSize = [UIScreen mainScreen].nativeBounds;
        screenSize.size.width /= [[UIScreen mainScreen] scale];
        screenSize.size.height /= [[UIScreen mainScreen] scale];
        
        CGPoint screenCenter = CGPointMake(screenSize.size.width / 2.0f, screenSize.size.height / 2.0f);
        CGPoint viewCenter = CGPointMake(svc.view.bounds.size.width / 2.0f, svc.view.bounds.size.height / 2.0f);
        CGPoint center = CGPointMake(screenCenter.x - viewCenter.x, screenCenter.y - viewCenter.y);
        CGPoint pos = CGPointMake(center.x - inViewRect.origin.x - inViewRect.size.width, center.y - (inViewRect.origin.y - viewCenter.y + inViewRect.size.height / 2.0f));
        
        presentationController.sourceRect = CGRectMake(pos.x, pos.y, inView.bounds.size.width, inView.bounds.size.height);
    }
    else {
        presentationController.permittedArrowDirections = arrowDirections;
        presentationController.sourceRect = targetBounds;
    }
    
    popoverPresentationControllerShouldDismissPopover = YES;
    
    [parentViewController presentViewController:svc animated:animated completion:NULL];
    
    return presentationController;
}
/**
 @brief ポップオーバーの表示（svc, inView, arrowDirections, parentViewController, animated）
 @param	svc (UIViewController *)                    ポップオーバーに表示するviewController
 @param	inView (UIView *)                           吹き出しを当てるview
 @param arrowDirections (UIPopoverArrowDirection)   吹き出しの方向
 @param parentViewController (UIViewController *)   ポップオーバーの親になるview（通常はself）
 @param animated (BOOL)                             アニメーションのON/OFF
 @return UIPopoverPresentationController
 */
+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                     permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                         parentViewController:(UIViewController *)parentViewController
                                                     animated:(BOOL)animated
{
    return [UIPopoverPresentationController presentPopoverController:svc inView:inView targetBounds:inView.bounds
                                            permittedArrowDirections:arrowDirections parentViewController:parentViewController animated:animated];
}

/**
 @brief ポップオーバーの表示（svc, inView, arrowDirections, parentViewController）
 @param	svc (UIViewController *)                    ポップオーバーに表示するviewController
 @param	inView (UIView *)                           吹き出しを当てるview
 @param arrowDirections (UIPopoverArrowDirection)   吹き出しの方向
 @param parentViewController (UIViewController *)   ポップオーバーの親になるview（通常はself）
 @return UIPopoverPresentationController
 */
+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                     permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                         parentViewController:(UIViewController *)parentViewController
{
    return [UIPopoverPresentationController presentPopoverController:svc inView:inView targetBounds:inView.bounds
                                            permittedArrowDirections:arrowDirections parentViewController:parentViewController animated:YES];
}

/**
 @brief ポップオーバーの表示（svc, inView, parentViewController）
 @param	svc (UIViewController *)                    ポップオーバーに表示するviewController
 @param	inView (UIView *)                           吹き出しを当てるview
 @param parentViewController (UIViewController *)   ポップオーバーの親になるview（通常はself）
 @return UIPopoverPresentationController
 */
+ (UIPopoverPresentationController *)presentPopoverController:(UIViewController *)svc
                                                       inView:(UIView *)inView
                                         parentViewController:(UIViewController *)parentViewController
{
    return [UIPopoverPresentationController presentPopoverController:svc inView:inView  targetBounds:inView.bounds
                                            permittedArrowDirections:UIPopoverArrowDirectionAny parentViewController:parentViewController animated:YES];
}

/**
 @brief ポップオーバーの終了
 @param animated (BOOL) アニメーションのON/OFF
 */
- (void)dismissPopoverAnimated:(BOOL)animated {
    [self.presentedViewController dismissViewControllerAnimated:animated completion:nil];
}

/**
 @brief 枠線を追加
 */
- (void)setFrameBorder {
    [self setFrameBorderWithBorderColor:[UIPopoverPresentationController defaultBorderColor] borderWidth:defaultBorderWidth];
}
/**
 @brief 枠線を追加
 @param borderColor (UIColor *)	枠線の色
 */
- (void)setFrameBorderWithBorderColor:(UIColor *)borderColor {
    [self setFrameBorderWithBorderColor:borderColor borderWidth:defaultBorderWidth];
}
/**
 @brief 枠線を追加
 @param borderWidth (CGFloat)	枠線の幅
 */
- (void)setFrameBorderWithBorderWidth:(CGFloat)borderWidth {
    [self setFrameBorderWithBorderColor:[UIPopoverPresentationController defaultBorderColor] borderWidth:borderWidth];
}
/**
 @brief 枠線を追加
 @param borderColor (UIColor *)	枠線の色
 @param borderWidth (CGFloat)	枠線の幅
 */
- (void)setFrameBorderWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    [[self.presentedViewController.view layer] setBorderColor:[borderColor CGColor]];
    [[self.presentedViewController.view layer] setBorderWidth:borderWidth];
    self.presentedViewController.view.layer.cornerRadius = defaultBorderRadius;
}
/**
 @brief ポップオーバー外をタップした際にポップオーバーを消すか否かを設定する
 @param flg (BOOL) 閉じるならYES,閉じないならNO
 */
- (void)setPopoverPresentationControllerShouldDismissPopover:(BOOL)flg {
    popoverPresentationControllerShouldDismissPopover = flg;
}

#pragma mark - UIPopoverPresentationControllerDelegate

// ポップオーバー外タップ時（YESを返すと閉じる）
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return popoverPresentationControllerShouldDismissPopover;
}

// ポップオーバー外タップで閉じられた後
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    
}

// ポップオーバーが表示される前
- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
{
    
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end

/*------------------------------------------------------------------------------------------------------------------------------------------
 ポップオーバーの影を設定するカテゴリクラス
 -----------------------------------------------------------------------------------------------------------------------------------------*/
@implementation UIPopoverBackgroundView (shadow)

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 影の強度設定
    self.layer.shadowOpacity = 0.3f;
    // 影を角丸にする
    self.layer.shadowRadius = 10.0f;
    // 影の範囲設定
    UIBezierPath *path;
    if (self.arrowDirection == UIPopoverArrowDirectionUp) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(-5.0f, 10.0f, self.layer.bounds.size.width + 10.0, self.layer.bounds.size.height + 10.0f)];
    }
    else if (self.arrowDirection == UIPopoverArrowDirectionDown) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(-5.0f, -5.0f, self.layer.bounds.size.width + 10.0, self.layer.bounds.size.height + 10.0)];
    }
    else if (self.arrowDirection == UIPopoverArrowDirectionLeft) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(-10.0f, 0.0f, self.layer.bounds.size.width + 10.0, self.layer.bounds.size.height + 10.0f)];
    }
    else if (self.arrowDirection == UIPopoverArrowDirectionRight) {
        path = [UIBezierPath bezierPathWithRect:CGRectMake(-15.0f, 0.0f, self.layer.bounds.size.width + 10.0, self.layer.bounds.size.height + 10.0f)];
    }
    self.layer.shadowPath = [path CGPath];
}

@end

/*------------------------------------------------------------------------------------------------------------------------------------------
 ポップオーバーの吹き出し含む背景を消すためのクラス
 -----------------------------------------------------------------------------------------------------------------------------------------*/
@interface NoBalloonPopoverBackgroundView () {
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}
@end

@implementation NoBalloonPopoverBackgroundView
+ (CGFloat)arrowHeight {
    return 0.0f;
}

+ (UIEdgeInsets)contentViewInsets {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}

- (CGFloat)arrowOffset {
    return _arrowOffset;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}

@end

