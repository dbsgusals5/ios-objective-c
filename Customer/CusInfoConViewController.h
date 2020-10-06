//
//  CusInfoConViewController.h
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/06.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CusInfoConViewController : ViewController
@property (nonatomic) NSDictionary *CusInfoDic;
@property (nonatomic) NSArray *array;
@property (weak, nonatomic) IBOutlet UILabel *NameKana;
- (void)test:(NSDictionary *)dic CustomerNumber:(NSString *)customerNumber;
-(void)InfoClear;


@end

NS_ASSUME_NONNULL_END
