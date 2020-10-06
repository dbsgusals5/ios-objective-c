//
//  CusInfoTableViewCell.h
//  iPadCourceYun
//
//  Created by alpha on 2019/09/10.
//  Copyright © 2019 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CusInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CusName;
@property (weak, nonatomic) IBOutlet UILabel *CusNumber;
@property (weak, nonatomic) IBOutlet UILabel *CusAddr;
@property (weak, nonatomic) IBOutlet UILabel *LastJoin;
@property (weak, nonatomic) IBOutlet UILabel *NextJoin;
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;
@property (weak, nonatomic) IBOutlet UIImageView *VisitImg;
@property (weak, nonatomic) IBOutlet UIImageView *RankImage;

@end

NS_ASSUME_NONNULL_END
