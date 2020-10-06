//
//  NegoUpdateViewController.h
//  iPadCourceYun
//
//  Created by alpha on 2019/09/19.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RenewData)(void);
@interface NegoRegistViewController : ViewController

@property (nonatomic) NSString *CusNum;
@property (weak, nonatomic) IBOutlet UITextField *NegoDateTextField;
@property (nonatomic) NSDictionary *insertedDic;
-(void) RenewData : (RenewData) block;
-(void) RegistReq : (NSString *)cusNum;
@end

NS_ASSUME_NONNULL_END

