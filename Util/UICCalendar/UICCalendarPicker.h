// ※ARC比対応プロジェクト、コンパイルオプションに-fno-objc-arc必要

#import <UIKit/UIKit.h>

@class UICCalendarPickerDateButton;

typedef enum {
	UICCalendarPickerSizeSmall,
	UICCalendarPickerSizeMedium,
	UICCalendarPickerSizeLarge,
	UICCalendarPickerSizeExtraLarge,
	UICCalendarPickerSizeIPadMedium,
} UICCalendarPickerSize;

typedef enum {
	UICCalendarPickerStyleDefault,
	UICCalendarPickerStyleBlackOpaque,
	UICCalendarPickerStyleBlackTranslucent,
} UICCalendarPickerStyle;

typedef enum {
	UICCalendarPickerSelectionModeSingleSelection,
	UICCalendarPickerSelectionModeMultiSelection,
	UICCalendarPickerSelectionModeRangeSelection,
} UICCalendarPickerSelectionMode;

typedef NS_ENUM(NSInteger, UICCalendarPickerDayOfWeek) {
	UICCalendarPickerDayOfWeekSunday = 1,
	UICCalendarPickerDayOfWeekMonday,
	UICCalendarPickerDayOfWeekTuesday,
	UICCalendarPickerDayOfWeekWednesday,
	UICCalendarPickerDayOfWeekThursday,
	UICCalendarPickerDayOfWeekFriday,
	UICCalendarPickerDayOfWeekSaturday,
} ;

@class UICCalendarPicker;

@protocol UICCalendarPickerDelegate<NSObject>
@optional
- (void)picker:(UICCalendarPicker *)picker pushedCloseButton:(id)sender;
- (void)picker:(UICCalendarPicker *)picker pushedPrevButton:(id)sender;
- (void)picker:(UICCalendarPicker *)picker pushedNextButton:(id)sender;
- (void)picker:(UICCalendarPicker *)picker didSelectDate:(NSArray *)selectedDate;
@end

@protocol UICCalendarPickerDataSource<NSObject>
@optional
- (NSString *)picker:(UICCalendarPicker *)picker textForYearMonth:(NSDate *)aDate;
- (void)picker:(UICCalendarPicker *)picker buttonForDateToday:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateNowday:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateHoliday:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateWeekday:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateSaturday:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateSunday:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateMonthOut:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateOutOfRange:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateSelected:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDateBlank:(UICCalendarPickerDateButton *)button;
- (void)picker:(UICCalendarPicker *)picker buttonForDate:(UICCalendarPickerDateButton *)button;
@end

@interface UICCalendarPicker : UIImageView {
	id<UICCalendarPickerDelegate> delegate;
	id<UICCalendarPickerDataSource> dataSource;
	
	UICCalendarPickerStyle style;
	UICCalendarPickerSelectionMode selectionMode;
	
	NSString *titleText;
	NSArray *weekText;
	
	NSDate *pageDate;
	NSDate *currentDate;
	NSDate *today;      // 指定された選択日付
    NSDate *nowday;     // 現在の日付
    NSMutableArray *holidaylist;// 指定の月のひと月分の祝日

	NSInteger lastSelected;
	NSMutableArray *selectedDates;
	
	NSDate *rangeStartDate;
	NSDate *rangeEndDate;
	
	NSDate *minDate;
	NSDate *maxDate;
	
	NSCalendar *gregorian;
	NSDateFormatter *dateFormatter;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id dataSource;

@property (nonatomic) UICCalendarPickerStyle style;
@property (nonatomic) UICCalendarPickerSelectionMode selectionMode;

@property (nonatomic, retain) NSString *titleText;
@property (nonatomic, retain, setter = setWeekText:) NSArray *weekText;

@property (nonatomic, retain, readonly) NSMutableArray *selectedDates;

@property (nonatomic, retain) NSDate *pageDate;
@property (nonatomic, retain) NSDate *today;
@property (nonatomic, retain) NSDate *nowday;
@property (nonatomic, retain) NSArray *holidaylist;

@property (nonatomic, retain, setter = setMinDate:) NSDate *minDate;
@property (nonatomic, retain, setter = setMaxDate:) NSDate *maxDate;

@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIButton *prevButton;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *prevYearButton;
@property (nonatomic, retain) UIButton *nextYearButton;

@property (nonatomic, retain) UIButton *setNowDayButton;				// 本日の日付設定ボタン(ポインタのみ)
@property (nonatomic, retain) UIBarButtonItem *setNowDayBarButton;		// 本日の日付設定ボタン(ポインタのみ)
@property (nonatomic, retain) UIButton *getHolidayListButton;			// 祝日カレンダー取得ボタン(ポインタのみ)
@property (nonatomic, retain) UIBarButtonItem *getHolidayListBarButton;	// 祝日カレンダー取得ボタン(バーボタンポインタのみ)


- (id)init;
- (id)initWithSize:(UICCalendarPickerSize)viewSize;
- (void)addSelectedDate:(NSDate *)aDate;
- (void)addSelectedDates:(NSArray *)dates;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)showAtPoint:(CGPoint)point inView:(UIView *)aView animated:(BOOL)animated;
- (void)dismiss:(id)sender animated:(BOOL)animated;
- (void)setUpCalendarWithDate:(NSDate *)aDate;

@end
