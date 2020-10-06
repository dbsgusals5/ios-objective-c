//
//  TimePickerUtil.h
//  HousingPortal
//
//  Created by アルファー on 2019/02/04.
//  Copyright © 2019年 alpha. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimePickerCompletion)(NSString* timeStr);

@interface TimePickerUtil : UIViewController
+ (void) target : (UIViewController*) target
      soureView : (UIView*) view
   withDateTime : (NSString*) hhmm
     completion : (TimePickerCompletion) completion;
@end
