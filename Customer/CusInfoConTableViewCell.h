//
//  CusInfoConTableViewCell.h
//  iPadCourceYun
//
//  Created by alpha on 2019/09/11.
//  Copyright © 2019 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CusInfoConTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *IntroDate;
@property (weak, nonatomic) IBOutlet UILabel *IntroName;
@property (weak, nonatomic) IBOutlet UILabel *IntroNameKana;
@property (weak, nonatomic) IBOutlet UILabel *UserAddr;
@property (weak, nonatomic) IBOutlet UILabel *UserTel;
@property (weak, nonatomic) IBOutlet UILabel *WorkName;
@property (weak, nonatomic) IBOutlet UILabel *UserRel;
@property (weak, nonatomic) IBOutlet UILabel *Comment;

@end

NS_ASSUME_NONNULL_END
