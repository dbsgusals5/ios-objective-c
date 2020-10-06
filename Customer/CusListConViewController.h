//
//  CusListConViewController.h
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/06.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CusListConViewController : ViewController
@property (nonatomic) NSDictionary *CusNegoDic;
@property (nonatomic) NSArray *array;
@property (nonatomic) NSIndexPath *CheckedIndex;
@property (nonatomic) NSDictionary *PromisingDic;

- (void)conNego:(NSDictionary *)dic;
- (void)PromisingInformation:(NSDictionary *)promisingInformation;
- (void)ListClear;
@end

NS_ASSUME_NONNULL_END
