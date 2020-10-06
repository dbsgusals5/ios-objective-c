//
//  DataController.h
//  iPadCourceYun
//
//  Created by alpha on 2019/10/10.
//  Copyright © 2019 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^completeBlock)(NSDictionary *result);
@interface DataController : NSObject
@property (nonatomic) completeBlock complete;
+(void)dbConn:(NSString *)authId dic:(NSDictionary *)dic initMode:(int)initMode complete:(completeBlock)complete;
@end

NS_ASSUME_NONNULL_END
