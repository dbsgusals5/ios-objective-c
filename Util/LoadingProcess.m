//
//  LoadingProcess.m
//  HousingPortal
//
//  Created by アルファー on 2018/12/05.
//  Copyright © 2018年 alpha. All rights reserved.
//

#import "LoadingProcess.h"

@interface LoadingProcess ()
@property (nonatomic) UIView *loadingView;
@property (nonatomic) BOOL showFlg;
@property (nonatomic) int showCount;
@end

@implementation LoadingProcess

+ (LoadingProcess*)Instance {
    static id intid = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        intid = [class new];
    });
    return intid;
}

- (id)init
{
    self = [super init];
    if (self) {
        if(self.loadingView == nil) {
            [self initLoadingView];
        }
    }
    return self;
}

- (void) initLoadingView {
    _loadingView = [UIView new];
    [_loadingView setFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
    [_loadingView setAlpha:0.0f];
    [_loadingView setClipsToBounds:YES];
    [_loadingView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    
    UIView* subView = [UIView new];
    [subView setFrame:CGRectMake(0.0f, 0.0f, 120.0f, 120.0f)];
    [subView setCenter:_loadingView.center];
    [subView setBackgroundColor:[UIColor colorWithRed:77.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0f]];
    
    UILabel *loadLabel = [UILabel new];
    [loadLabel setFrame:CGRectMake(15, 15, 90, 35)];
    [loadLabel setText:@"Loading..."];
    [loadLabel setTextColor:[UIColor whiteColor]];
    [loadLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [loadLabel setTextAlignment:NSTextAlignmentCenter];
    [loadLabel setBackgroundColor:[UIColor clearColor]];
    [subView addSubview:loadLabel];

    UIActivityIndicatorView* activetyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activetyView setFrame:CGRectMake(41, 60, 37, 37)];
    [activetyView startAnimating];
    [subView addSubview:activetyView];
    
    [_loadingView addSubview:subView];
    
    _showFlg = NO;
    
    [[self parentView] addSubview:_loadingView];
}

- (UIView*) parentView {
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    UIView *view = topController.view;
    while (view.superview) {
        view = view.superview;
    }
    return view;
}

+ (void)showLoading {
    [LoadingProcess Instance].showCount++;
     if([LoadingProcess Instance].showFlg) { return; }
    [UIView animateWithDuration:0.0f animations:^{
        [LoadingProcess Instance].loadingView.alpha = 1.0f;
        [LoadingProcess Instance].showFlg = YES;
    }];
}

+ (void)hideLoading {
    [LoadingProcess Instance].showCount--;
     if(![LoadingProcess Instance].showFlg
        || [LoadingProcess Instance].showCount > 0){
         return;
     }
    [UIView animateWithDuration:0.75f animations:^{
        [LoadingProcess Instance].loadingView.alpha = 0.0f;
        [LoadingProcess Instance].showFlg = NO;
    }];
}
@end
