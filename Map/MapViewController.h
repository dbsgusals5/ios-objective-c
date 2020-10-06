//
//  MapViewController.h
//  iPadCourceYun
//
//  Created by alpha on 2019/09/12.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : ViewController
@property (nonatomic) NSString *CusName;
@property (nonatomic) NSString *CusAddr;
@property (weak, nonatomic) IBOutlet UILabel *CusNameText;
@property (weak, nonatomic) IBOutlet UILabel *CusAddrText;

@end

NS_ASSUME_NONNULL_END
