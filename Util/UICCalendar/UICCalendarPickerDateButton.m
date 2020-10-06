#import "UICCalendarPickerDateButton.h"

@implementation UICCalendarPickerDateButton

@synthesize date;
@synthesize dayOfWeek;
@synthesize monthout;
@synthesize outOfRange;

- (id)init
{
	if (self = [super init]) {
		button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        button.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
		date = nil;
		isToday = NO;
		dayOfWeek = UICCalendarPickerDayOfWeekSunday;
		outOfRange = NO;
	}
	return self;
}

- (void)dealloc
{
	[date release];
	[button release];
	[super dealloc];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	if ([button respondsToSelector:[anInvocation selector]]) {
		[anInvocation invokeWithTarget:button];
	} else {
		[super forwardInvocation:anInvocation];
	}
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
	if (signature == nil) {
		signature = [button methodSignatureForSelector:aSelector];
	}
	return signature;
}

- (BOOL)isToday {
	return isToday;
}
- (BOOL)isNowday {
	return isNowday;
}
- (BOOL)isHoliday {
	return isHoliday;
}

- (void)setToday:(BOOL)b {
	isToday = b;
}

- (void)setNowday:(BOOL)b {
	isNowday = b;
}

- (void)setHoliday:(BOOL)b {
	isHoliday = b;
}

@end
