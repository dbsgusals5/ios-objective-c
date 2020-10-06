//
//  CusListConTableViewCell.h
//  iPadCourceYun
//
//  Created by alpha on 2019/09/13.
//  Copyright © 2019 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CusListConTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NegoDate;
@property (weak, nonatomic) IBOutlet UILabel *SalesName;
@property (weak, nonatomic) IBOutlet UILabel *NegoMeans;
@property (weak, nonatomic) IBOutlet UILabel *NegoPartner;
@property (weak, nonatomic) IBOutlet UILabel *NextNegoDate;
@property (weak, nonatomic) IBOutlet UILabel *NegoContent;
@property (weak, nonatomic) IBOutlet UILabel *NegoPlan;

@end

NS_ASSUME_NONNULL_END
