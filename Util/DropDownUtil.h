//
//  DropDownUtil.h
//  HousingPortal
//
//  Created by アルファー on 2019/02/01.
//  Copyright © 2019年 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DropDownCompletion)(NSDictionary* selectedData);

@interface DropDownUtil : UIViewController
+ (void)  target : (UIViewController*) target
   withSoureView : (UIView*) soureView
  withOptionList : (NSArray*) optionArray
withSelectedValue : (NSString*) selectedValue
    completion : (DropDownCompletion) completion;
@end

@interface DropDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@end
