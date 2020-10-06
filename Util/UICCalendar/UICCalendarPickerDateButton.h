// ※ARC比対応プロジェクト、コンパイルオプションに-fno-objc-arc必要

#import <UIKit/UIKit.h>
#import "UICCalendarPicker.h"

@interface UICCalendarPickerDateButton : UIButton {
	UIButton *button;
	NSDate *date;
	BOOL isToday;
	BOOL isNowday;
	BOOL isHoliday;
	UICCalendarPickerDayOfWeek dayOfWeek;
	BOOL monthout;
	BOOL outOfRange;
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, getter = isToday, setter = setToday:) BOOL isToday;
@property (nonatomic, getter = isNowday, setter = setNowday:) BOOL isNowday;
@property (nonatomic, getter = isHoliday, setter = setHoliday:) BOOL isHoliday;
@property (nonatomic) UICCalendarPickerDayOfWeek dayOfWeek;
@property (nonatomic) BOOL monthout;
@property (nonatomic) BOOL outOfRange;

@end
