//
//  NegoRegMeansViewController.h
//  iPadCourceYun
//
//  Created by alpha on 2019/09/24.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NegoMeansCompletion)(NSString* MeansStr);

@interface NegoRegMeansViewController : ViewController
@property (nonatomic) NSArray *negoRegContArray;
+ (void)target:(UIViewController *)target soureView:(UIView *)view completion:(NegoMeansCompletion)completion;
@end

NS_ASSUME_NONNULL_END
