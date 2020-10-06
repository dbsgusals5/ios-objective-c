//
//  NegoRegOtherViewController.h
//  iPadCourceYun
//
//  Created by alpha on 2019/09/24.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^NegoOthersCompletion)(NSString* OtherStr);

@interface NegoRegOtherViewController : ViewController
@property (nonatomic) NSArray *negoRegOthersArray;
+ (void)target:(UIViewController *)target soureView:(UIView *)view completion:(NegoOthersCompletion)completion;
@end

NS_ASSUME_NONNULL_END
