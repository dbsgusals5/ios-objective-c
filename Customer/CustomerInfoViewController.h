//
//  CustomerInfoViewController.h
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/05.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomerInfoViewController : ViewController

@property (nonatomic) NSDictionary *CusDic;
@property (weak,nonatomic) NSString *UserName;
@property (weak,nonatomic) NSString *PassCode;
@property (nonatomic) NSArray *array;
@property (nonatomic) IBOutlet UIView *CusListConView;
@property (nonatomic) IBOutlet UIView *CusInfoConView;
@property (nonatomic) NSArray *NameArray;
@property (nonatomic) NSArray *arrayCp;


@end

NS_ASSUME_NONNULL_END
