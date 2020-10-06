#import "UICCalendarPicker.h"
#import "UICCalendarPickerDateButton.h"
#import "CustomCalender.h"

#define UICCALENDAR_CALENDAR_VIEW_WIDTH 204.0f
#define UICCALENDAR_CALENDAR_VIEW_HEIGHT 234.0f

#define UICCALENDAR_CONTROL_BUTTON_SMALL_WIDTH 25.0f
#define UICCALENDAR_CONTROL_BUTTON_SMALL_HEIGHT 15.0f
#define UICCALENDAR_CONTROL_BUTTON_MEDIUM_WIDTH 27.0f
#define UICCALENDAR_CONTROL_BUTTON_MEDIUM_HEIGHT 16.0f
#define UICCALENDAR_CONTROL_BUTTON_LARGE_WIDTH 30.0f
#define UICCALENDAR_CONTROL_BUTTON_LARGE_HEIGHT 18.0f
#define UICCALENDAR_CONTROL_BUTTON_EXTRALARGE_WIDTH 32.0f
#define UICCALENDAR_CONTROL_BUTTON_EXTRALARGE_HEIGHT 19.0f
#define UICCALENDAR_CONTROL_BUTTON_IPADMEDIUM_WIDTH 68.0f
#define UICCALENDAR_CONTROL_BUTTON_IPADMEDIUM_HEIGHT 37.0f

//#define UICCALENDAR_TITLE_FONT_SIZE 13.0f
#define UICCALENDAR_TITLE_FONT_SIZE 16.0f
#define UICCALENDAR_TITLE_LABEL_WIDTH 140.0f
#define UICCALENDAR_TITLE_LABEL_HEIGHT 25.0f

#define UICCALENDAR_TITLE_LABEL_TAG 100
#define UICCALENDAR_MONTH_LABEL_TAG 200
#define UICCALENDAR_WEEK_LABEL_TAG 300

//#define UICCALENDAR_CELL_FONT_SIZE 13.0f
#define UICCALENDAR_CELL_FONT_SIZE 14.0f
#define UICCALENDAR_CELL_SMALL_WIDTH 27.0f
#define UICCALENDAR_CELL_SMALL_HEIGHT 24.0f
#define UICCALENDAR_CELL_MEDIUM_WIDTH 29.0f
#define UICCALENDAR_CELL_MEDIUM_HEIGHT 26.0f
#define UICCALENDAR_CELL_LARGE_WIDTH 33.0f
#define UICCALENDAR_CELL_LARGE_HEIGHT 28.0f
#define UICCALENDAR_CELL_EXTRALARGE_WIDTH 35.0f
#define UICCALENDAR_CELL_EXTRALARGE_HEIGHT 31.0f
#define UICCALENDAR_CELL_IPADMEDIUM_WIDTH 80.0f
#define UICCALENDAR_CELL_IPADMEDIUM_HEIGHT 58.0f

// 休日リストを取得するURL
#define HolidayCalendarURL @"http://www.apple.com/downloads/macosx/calendars/japaneseholidaycalendar.html"


@interface UICCalendarPicker(Private)
- (void)closeButtonPushed:(id)sender;
- (void)prevButtonPushed:(id)sender;
- (void)nextButtonPushed:(id)sender;
- (void)prevYearButtonPushed:(id)sender;
- (void)nextYearButtonPushed:(id)sender;
- (void)dateButtonPushed:(id)sender;
- (void)moveLastMonth:(id)sender;
- (void)moveNextMonth:(id)sender;
- (void)addRangeDateObjects;
- (void)resetButtonAtributes:(UICCalendarPickerDateButton *)button;
- (void)resetButtonState:(UICCalendarPickerDateButton *)button;
- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date;
- (void)getHolidayCalendar;
- (void)tapNowDayButton;
@end

@implementation UICCalendarPicker

static float controlButtonWidth[] = 
{UICCALENDAR_CONTROL_BUTTON_SMALL_WIDTH, UICCALENDAR_CONTROL_BUTTON_MEDIUM_WIDTH, UICCALENDAR_CONTROL_BUTTON_LARGE_WIDTH, UICCALENDAR_CONTROL_BUTTON_EXTRALARGE_WIDTH, UICCALENDAR_CONTROL_BUTTON_IPADMEDIUM_WIDTH};
static float controlButtonHeight[] = 
{UICCALENDAR_CONTROL_BUTTON_SMALL_HEIGHT, UICCALENDAR_CONTROL_BUTTON_MEDIUM_HEIGHT, UICCALENDAR_CONTROL_BUTTON_LARGE_HEIGHT, UICCALENDAR_CONTROL_BUTTON_EXTRALARGE_HEIGHT, UICCALENDAR_CONTROL_BUTTON_IPADMEDIUM_HEIGHT};
static float cellWidth[] = 
{UICCALENDAR_CELL_SMALL_WIDTH, UICCALENDAR_CELL_MEDIUM_WIDTH, UICCALENDAR_CELL_LARGE_WIDTH, UICCALENDAR_CELL_EXTRALARGE_WIDTH, UICCALENDAR_CELL_IPADMEDIUM_WIDTH};
static float cellHeight[] = 
{UICCALENDAR_CELL_SMALL_HEIGHT, UICCALENDAR_CELL_MEDIUM_HEIGHT, UICCALENDAR_CELL_LARGE_HEIGHT, UICCALENDAR_CELL_EXTRALARGE_HEIGHT, UICCALENDAR_CELL_IPADMEDIUM_HEIGHT};

static UIImage *normalCell;
static UIImage *selectedCell;
static UIImage *disabledCell;
static UIImage *monthoutCell;
static UIImage *holidayCell;
static UIImage *todayCell;
//static UIImage *todayframeCell;
static UIImage *nowdayCell;
static UIImage *todaySelectedCell;
static UIImage *tmpCellImage;

static UIColor *normalColor;
static UIColor *selectedColor;
static UIColor *disabledColor;
static UIColor *monthoutColor;
static UIColor *holidayColor;
static UIColor *tmpCellColor;

@synthesize titleText;
@synthesize weekText;

@synthesize delegate;
@synthesize dataSource;

@synthesize style;
@synthesize selectionMode;

@synthesize pageDate;
@synthesize today;
@synthesize nowday;
@synthesize holidaylist;

@synthesize selectedDates;

@synthesize minDate;
@synthesize maxDate;

+ (void)initialize
{
	normalCell = [[UIImage imageNamed:@"uiccalendar_cell_normal.png"] retain];
	selectedCell = [[UIImage imageNamed:@"uiccalendar_cell_selected.png"] retain];
	disabledCell = [[UIImage imageNamed:@"uiccalendar_cell_disabled.png"] retain];
	monthoutCell = [[UIImage imageNamed:@"uiccalendar_cell_monthout.png"] retain];
	holidayCell = [[UIImage imageNamed:@"uiccalendar_cell_holiday.png"] retain];
	todayCell = [[UIImage imageNamed:@"uiccalendar_cell_frame"] retain];
//	todayframeCell = [[UIImage imageNamed:@"uiccalendar_cell_frame.png"] retain];
	nowdayCell = [[UIImage imageNamed:@"uiccalendar_cell_custom1.png"] retain];
	todaySelectedCell = [[UIImage imageNamed:@"uiccalendar_cell_today_selected.png"] retain];
	
	normalColor = [[UIColor colorWithRed:77.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0f] retain];
	selectedColor = [[UIColor blackColor] retain];
	disabledColor = [[UIColor lightGrayColor] retain];
	monthoutColor = [[UIColor darkGrayColor] retain];
	holidayColor = [[UIColor colorWithRed:154.0f/255.0f green:28.0f/255.0f blue:13.0f/255.0f alpha:1.0f] retain];
}

- (id)init {
	return [self initWithSize:UICCalendarPickerSizeMedium];
}

- (id)initWithSize:(UICCalendarPickerSize)viewSize
{
	if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, cellWidth[viewSize] * 7 - 6.0f + 21.0f, cellHeight[viewSize] * 6 - 5.0f + 95.0f)]) {
		//self.titleText = nil;//@"Calendar";
		self.weekText = [NSArray arrayWithObjects:@"日", @"月", @"火", @"水", @"木", @"金", @"土", nil];
		[self setImage:[UIImage imageNamed:@"uiccalendar_background.png"]];
		
		[self setUserInteractionEnabled:YES];
		
		self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
		[self.closeButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_close.png"] forState:UIControlStateNormal];
		[self.closeButton setFrame:CGRectMake(self.frame.size.width - 31.0f - viewSize * 3, 6.0f, controlButtonWidth[viewSize], controlButtonHeight[viewSize])];
		[self.closeButton setShowsTouchWhenHighlighted:NO];
		[self.closeButton addTarget:self action:@selector(closeButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.closeButton];
		
		self.prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.prevButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
		[self.prevButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_left_arrow.png"] forState:UIControlStateNormal];
//		[self.prevButton setFrame:CGRectMake(8.0f, 6.0f, controlButtonWidth[viewSize], controlButtonHeight[viewSize])];
		[self.prevButton setFrame:CGRectMake(62.0f, 8.0f, 46, 30)];
		[self.prevButton setShowsTouchWhenHighlighted:NO];
		[self.prevButton addTarget:self action:@selector(prevButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.prevButton];
		
		self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_right_arrow.png"] forState:UIControlStateNormal];
//		[self.nextButton setFrame:CGRectMake(self.frame.size.width - 63.0f - viewSize * 3, 6.0f, controlButtonWidth[viewSize], controlButtonHeight[viewSize])];
		[self.nextButton setFrame:CGRectMake(self.frame.size.width - 95.0f - viewSize * 3, 8.0f, 46, 30)];
		[self.nextButton setShowsTouchWhenHighlighted:NO];
		[self.nextButton addTarget:self action:@selector(nextButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.nextButton];
				
		self.prevYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.prevYearButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
		[self.prevYearButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_left_year_arrow"] forState:UIControlStateNormal];
		[self.prevYearButton setFrame:CGRectMake(8.0f, 8.0f, 46, 30)];
		[self.prevYearButton setShowsTouchWhenHighlighted:NO];
		[self.prevYearButton addTarget:self action:@selector(prevYearButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.prevYearButton];
		
		self.nextYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextYearButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
		[self.nextYearButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_right_year_arrow"] forState:UIControlStateNormal];
		[self.nextYearButton setFrame:CGRectMake(self.frame.size.width - 41.0f - viewSize * 3, 8.0f, 46, 30)];
		[self.nextYearButton setShowsTouchWhenHighlighted:NO];
		[self.nextYearButton addTarget:self action:@selector(nextYearButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.nextYearButton];
        
		UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[monthLabel setTag:UICCALENDAR_MONTH_LABEL_TAG];
		[monthLabel setBackgroundColor:[UIColor clearColor]];
		[monthLabel setTextColor:normalColor];
		[monthLabel setTextAlignment:NSTextAlignmentCenter];
		[monthLabel setFont:RegacyBoldSystemFontOfSize(UICCALENDAR_TITLE_FONT_SIZE)];
		[monthLabel setFrame:CGRectMake(self.frame.size.width / 2 - UICCALENDAR_TITLE_LABEL_WIDTH / 2, 10.0f + viewSize, UICCALENDAR_TITLE_LABEL_WIDTH, UICCALENDAR_TITLE_LABEL_HEIGHT)];
		[self addSubview:monthLabel];
		[monthLabel release];
        
        for (int i = 0; i < 7; i++) {
			UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
			[weekLabel setTag:UICCALENDAR_WEEK_LABEL_TAG + i];
			[weekLabel setBackgroundColor:[UIColor clearColor]];
			[weekLabel setTextColor:normalColor];
			[weekLabel setTextAlignment:NSTextAlignmentCenter];
			[weekLabel setFont:RegacyBoldSystemFontOfSize(UICCALENDAR_TITLE_FONT_SIZE)];
			[weekLabel setFrame:CGRectMake(11.0f + (cellWidth[viewSize] - 1) * (i % 7), 54.0f, cellWidth[viewSize] , UICCALENDAR_TITLE_LABEL_HEIGHT)];
			[weekLabel setText:[weekText objectAtIndex:i]];
			[self addSubview:weekLabel];
			[weekLabel release];
		}
		
		for (int i = 0; i < 42; i++) {
			UICCalendarPickerDateButton *dateButton = [[UICCalendarPickerDateButton alloc] init];
			[dateButton setFrame:
			 CGRectMake(11.0f + cellWidth[viewSize] * (i % 7) - (i % 7), 84.0f + cellHeight[viewSize] * (i / 7) - (i / 7), cellWidth[viewSize], cellHeight[viewSize])];
			[dateButton setTag:i + 1];
			[dateButton addTarget:self action:@selector(dateButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
			[self resetButtonAtributes:dateButton];
			[self addSubview:dateButton];
			[dateButton release];
		}
		
		selectedDates = [[NSMutableArray alloc] init];
		
		gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];
		
		NSDate *now = [NSDate date];
		NSDateComponents *todayComponents = [self getDateComponentsFromDate:now];
		today = [[gregorian dateFromComponents:todayComponents] retain];
		
		self.pageDate = today;
        
        // 祝日カレンダー取得ボタン作成
//        self.getHolidayListButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//        [self.getHolidayListButton addTarget:self action:@selector(getHolidayCalendar) forControlEvents:UIControlEventTouchUpInside];
		
		// メモリリークするためコメントアウト
//        self.getHolidayListBarButton = [[UIBarButtonItem alloc]
//                                        initWithTitle:NSLocalizedString(@"Btn.HolidayCalender", nil)  // ボタンタイトル名を指定
//                                        style:UIBarButtonItemStyleDone  // スタイルを指定
//                                        target:self  // デリゲートのターゲットを指定
//                                        action:@selector(getHolidayCalendar)  // ボタンが押されたときに呼ばれるメソッドを指定
//                                        ];
        
        // 本日の日付設定ボタン作成・・・・・
//        self.setNowDayButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//        [self.setNowDayButton addTarget:self action:@selector(tapNowDayButton) forControlEvents:UIControlEventTouchUpInside];
		
		// メモリリークするためコメントアウト
//        self.setNowDayBarButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:NSLocalizedString(@"Btn.NowDay", nil)  // ボタンタイトル名を指定
//                                   style:UIBarButtonItemStyleDone  // スタイルを指定
//                                   target:self  // デリゲートのターゲットを指定
//                                   action:@selector(tapNowDayButton)  // ボタンが押されたときに呼ばれるメソッドを指定
//                                   ];
    }
    return self;
}

- (void)dealloc
{
	[dateFormatter release];
	[gregorian release];
	
	[maxDate release];
	[minDate release];
	
	[rangeEndDate release];
	[rangeStartDate release];
	
	[selectedDates release];
	
	[today release];
	[currentDate release];
	[pageDate release];
	
	[weekText release];
	
	[nowday release];
	[holidaylist release];
    
//	[self.getHolidayListBarButton release];
//	[self.getHolidayListButton release];
//	[self.setNowDayBarButton release];
//	[self.setNowDayButton release];
	
	self.getHolidayListBarButton.action = nil;
	self.getHolidayListBarButton.target = nil;
    self.getHolidayListButton = nil;
    self.getHolidayListBarButton = nil;
	self.setNowDayBarButton.action = nil;
	self.setNowDayBarButton.target = nil;
    self.setNowDayButton = nil;
    self.setNowDayBarButton = nil;
	
	self.closeButton = nil;
	self.prevButton = nil;
	self.nextButton = nil;
	self.prevYearButton = nil;
	self.nextYearButton = nil;

    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

#pragma mark <UICCalendarPickerDataSource> Methods

- (NSString *)picker:(UICCalendarPicker *)picker textForYearMonth:(NSDate *)aDate {
	[dateFormatter setDateFormat:@"yyyy年M月"];
	return [dateFormatter stringFromDate:aDate];
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateToday:(UICCalendarPickerDateButton *)button {
	[self resetButtonState:button];
    if (tmpCellImage) {
//        UIGraphicsBeginImageContext(CGSizeMake(tmpCellImage.size.width, tmpCellImage.size.height));
//        [tmpCellImage drawAtPoint:CGPointMake(0, 0)];
//        [todayCell drawAtPoint:CGPointMake(0, 0)];
//        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        [button setBackgroundImage:todayCell forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:todayCell forState:UIControlStateNormal];
    }
    if (tmpCellColor) {
        [button setTitleColor:tmpCellColor forState:UIControlStateNormal];
    }
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateToday:)]) {
		[dataSource picker:self buttonForDateToday:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateNowday:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
    [button setBackgroundImage:nowdayCell forState:UIControlStateNormal];
    tmpCellImage = nowdayCell;
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateNowday:)]) {
		[dataSource picker:self buttonForDateNowday:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateHoliday:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
    [button setBackgroundImage:holidayCell forState:UIControlStateNormal];
    tmpCellImage = holidayCell;
	[button setTitleColor:holidayColor forState:UIControlStateNormal];
    tmpCellColor = holidayColor;
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateHoliday:)]) {
		[dataSource picker:self buttonForDateHoliday:button];
	}
}


- (void)picker:(UICCalendarPicker *)picker buttonForDateWeekday:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
	[button setBackgroundImage:normalCell forState:UIControlStateNormal];
    tmpCellImage = normalCell;
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateWeekday:)]) {
		[dataSource picker:self buttonForDateWeekday:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateSaturday:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
	[button setBackgroundImage:normalCell forState:UIControlStateNormal];
    tmpCellImage = normalCell;
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateSaturday:)]) {
		[dataSource picker:self buttonForDateSaturday:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateSunday:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
	[button setBackgroundImage:holidayCell forState:UIControlStateNormal];
    tmpCellImage = holidayCell;
	[button setTitleColor:holidayColor forState:UIControlStateNormal];
    tmpCellColor = holidayColor;
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateSunday:)]) {
		[dataSource picker:self buttonForDateSunday:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateMonthOut:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
	[button setBackgroundImage:monthoutCell forState:UIControlStateNormal];
	[button setTitleColor:monthoutColor forState:UIControlStateNormal];
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateMonthOut:)]) {
		[dataSource picker:self buttonForDateMonthOut:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateOutOfRange:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
	[button setEnabled:NO];
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateOutOfRange:)]) {
		[dataSource picker:self buttonForDateOutOfRange:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateSelected:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
	if (button.isToday) {
		[button setBackgroundImage:todaySelectedCell forState:UIControlStateSelected];
	} else {
		[button setBackgroundImage:selectedCell forState:UIControlStateSelected];
	}
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateSelected:)]) {
		[dataSource picker:self buttonForDateSelected:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDateBlank:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
	[button setSelected:NO];
	[button setEnabled:NO];
	if ([dataSource respondsToSelector:@selector(picker:buttonForDateBlank:)]) {
		[dataSource picker:self buttonForDateBlank:button];
	}
}

- (void)picker:(UICCalendarPicker *)picker buttonForDate:(UICCalendarPickerDateButton *)button
{
	[self resetButtonState:button];
    
    tmpCellImage = nil;
	tmpCellColor = nil;
    if (button.isHoliday) {
		[self picker:self buttonForDateHoliday:button];
	} else if (button.dayOfWeek == UICCalendarPickerDayOfWeekSunday) {
		[self picker:self buttonForDateSunday:button];
	} else if (button.dayOfWeek == UICCalendarPickerDayOfWeekSaturday) {
		[self picker:self buttonForDateSaturday:button];
	} else {
		[self picker:self buttonForDateWeekday:button];
	}

	
	if (button.isNowday) {
		[self picker:self buttonForDateNowday:button];
	}
	
	if (button.monthout) {
		[self picker:self buttonForDateMonthOut:button];
	}
	
	if (button.selected) {
		[self picker:self buttonForDateSelected:button];
	}
	
	if (button.outOfRange) {
		[self picker:self buttonForDateOutOfRange:button];
	}
	
	if (!button.date) {
		[self picker:self buttonForDateBlank:button];
	}
    
	if (button.isToday) {
		[self picker:self buttonForDateToday:button];
	}
}

#pragma mark <UICCalendarPicker> Methods


- (void)setWeekText:(NSArray *)text
{
	if (text != weekText) {
		[weekText release];
	}
	weekText = [text retain];
	int i = 0;
	for (NSString *s in text) {
		UILabel *weekLabel = (UILabel *)[self viewWithTag:UICCALENDAR_WEEK_LABEL_TAG + i];
		[weekLabel setText:s];
		i++;
	}
}

- (void)setToday:(NSDate *)aDate
{
	if (aDate != today) {
		[today release];
	}
	NSDateComponents *components = [self getDateComponentsFromDate:aDate];
	today = [[gregorian dateFromComponents:components] retain];
}

- (void)setNowday:(NSDate *)aDate
{
	if (aDate != nowday) {
		[nowday release];
	}
	NSDateComponents *components = [self getDateComponentsFromDate:aDate];
	nowday = [[gregorian dateFromComponents:components] retain];
}

- (void)setMinDate:(NSDate *)aDate
{
	if (aDate != minDate) {
		[minDate release];
	}
	NSDateComponents *components = [self getDateComponentsFromDate:aDate];
	minDate = [[gregorian dateFromComponents:components] retain]; 
}

- (void)setMaxDate:(NSDate *)aDate
{
	if (aDate != maxDate) {
		[maxDate release];
	}
	NSDateComponents *components = [self getDateComponentsFromDate:aDate];
	maxDate = [[gregorian dateFromComponents:components] retain];
}

- (void)addSelectedDate:(NSDate *)aDate
{
	NSDateComponents *components = [self getDateComponentsFromDate:aDate];
	[selectedDates addObject:[gregorian dateFromComponents:components]];
}

- (void)addSelectedDates:(NSArray *)dates
{
	for (NSDate *date in dates) {
		NSDateComponents *components = [self getDateComponentsFromDate:date];
		[selectedDates addObject:[gregorian dateFromComponents:components]];
	}
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
	[self setCenter:CGPointMake(aView.frame.size.width / 2, self.frame.size.height / 2)];
	
	[self setUpCalendarWithDate:pageDate];
	
	if (animated) {
		[self setAlpha:0.0f];
		[aView addSubview:self];
		
		CGRect frame = [self frame];
		frame.origin.y = frame.origin.y - frame.size.height / 2;
		self.frame = frame;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self setAlpha:1.0f];
		frame.origin.y = frame.origin.y + frame.size.height / 2;
		self.frame = frame;
		[UIView commitAnimations];
	} else {
		[aView addSubview:self];
	}
}

- (void)showAtPoint:(CGPoint)point inView:(UIView *)aView animated:(BOOL)animated
{
	[self setUpCalendarWithDate:pageDate];
	
	if (animated) {
		[self setAlpha:0.0f];
		[aView addSubview:self];
		
		CGRect frame = [self frame];
		frame.origin.x = point.x;
		frame.origin.y = point.y - frame.size.height / 2;
		self.frame = frame;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self setAlpha:1.0f];
		frame.origin.y = frame.origin.y + frame.size.height / 2;
		self.frame = frame;
		[UIView commitAnimations];
	} else {
		CGRect frame = [self frame];
		frame.origin.x = point.x;
		frame.origin.y = point.y;
		self.frame = frame;
		[aView addSubview:self];
	}
}

- (void)dismiss:(id)sender animated:(BOOL)animated
{
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self setAlpha:0.0f];
		CGRect frame = [self frame];
		frame.origin.y = frame.origin.y - frame.size.height / 2;
		self.frame = frame;
		[UIView commitAnimations];
	} else {
		[self removeFromSuperview];
	}
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[self removeFromSuperview];
}

#pragma mark Private Methods

- (void)resetButtonAtributes:(UICCalendarPickerDateButton *)button
{
	[button setDate:nil];
	[button setToday:NO];
	[button setNowday:NO];
	[button setDayOfWeek:UICCalendarPickerDayOfWeekSunday];
	[button setMonthout:NO];
	[button setOutOfRange:NO];
	[button setEnabled:YES];
	[button setBackgroundImage:normalCell forState:UIControlStateNormal];
	[button setBackgroundImage:selectedCell forState:UIControlStateSelected];
	[button setBackgroundImage:disabledCell forState:UIControlStateDisabled];
	[button setTitleColor:normalColor forState:UIControlStateNormal];
	[button setTitleColor:selectedColor forState:UIControlStateSelected];
	[button setTitleColor:disabledColor forState:UIControlStateDisabled];
	//[button setFont:RegacySystemFontOfSize(UICCALENDAR_CELL_FONT_SIZE)]; // deprecated
    [button.titleLabel setFont:RegacyBoldSystemFontOfSize(UICCALENDAR_CELL_FONT_SIZE)];
    
	[button setShowsTouchWhenHighlighted:NO];
}

- (void)resetButtonState:(UICCalendarPickerDateButton *)button
{
	[button setBackgroundImage:normalCell forState:UIControlStateNormal];
	[button setBackgroundImage:selectedCell forState:UIControlStateSelected];
	[button setBackgroundImage:disabledCell forState:UIControlStateDisabled];
	[button setTitleColor:normalColor forState:UIControlStateNormal];
	[button setTitleColor:selectedColor forState:UIControlStateSelected];
	[button setTitleColor:disabledColor forState:UIControlStateDisabled];
	//[button setFont:RegacySystemFontOfSize(UICCALENDAR_CELL_FONT_SIZE)]; // deprecated
    [button.titleLabel setFont:RegacyBoldSystemFontOfSize(UICCALENDAR_CELL_FONT_SIZE)];
	[button setShowsTouchWhenHighlighted:NO];
}

- (void)closeButtonPushed:(id)sender
{
	if ([delegate respondsToSelector:@selector(picker:pushedCloseButton:)]) {
		[delegate picker:self pushedCloseButton:sender];
	} else {
		[self dismiss:sender animated:YES];
	}
}

- (void)prevButtonPushed:(id)sender
{
	if ([delegate respondsToSelector:@selector(picker:pushedPrevButton:)]) {
		[delegate picker:self pushedPrevButton:sender];
	} else {
		[self moveLastMonth:sender];
	}
}

- (void)nextButtonPushed:(id)sender
{
	if ([delegate respondsToSelector:@selector(picker:pushedNextButton:)]) {
		[delegate picker:self pushedNextButton:sender];
	} else {
		[self moveNextMonth:sender];
	}
}

- (void)dateButtonPushed:(id)sender
{
	@synchronized(self) {
		
		UICCalendarPickerDateButton *dateButton = (UICCalendarPickerDateButton *)sender;
		
		if (selectionMode == UICCalendarPickerSelectionModeSingleSelection) {
			
			[selectedDates removeAllObjects];
			UICCalendarPickerDateButton *lastSelectedButton = (UICCalendarPickerDateButton *)[self viewWithTag:lastSelected];
			
			if (lastSelected == 0) {
				
				if ([[dateButton date] isEqualToDate:today]) {
					[dateButton setBackgroundImage:todaySelectedCell forState:UIControlStateSelected];
				} else {
					[dateButton setBackgroundImage:selectedCell forState:UIControlStateSelected];
				}
				
				[dateButton setSelected:YES];
				lastSelected = [dateButton tag];
				[selectedDates addObject:[dateButton date]];
				
			} else if (dateButton == lastSelectedButton) {
				
				[dateButton setSelected:NO];
				lastSelected = 0;
				
			} else {
				
				if ([[dateButton date] isEqualToDate:today]) {
					[dateButton setBackgroundImage:todaySelectedCell forState:UIControlStateSelected];
				} else {
					[dateButton setBackgroundImage:selectedCell forState:UIControlStateSelected];
				}
				
				[lastSelectedButton setSelected:NO];
				[dateButton setSelected:YES];
				lastSelected = [dateButton tag];
				[selectedDates addObject:[dateButton date]];
				
			}
			
		} else if (selectionMode == UICCalendarPickerSelectionModeMultiSelection) {
			
			if ([dateButton isSelected]) {
				
				[dateButton setSelected:NO];
				[selectedDates removeObject:[dateButton date]];
				
			} else {
				
				if ([[dateButton date] isEqualToDate:today]) {
					[dateButton setBackgroundImage:todaySelectedCell forState:UIControlStateSelected];
				} else {
					[dateButton setBackgroundImage:selectedCell forState:UIControlStateSelected];
				}
				
				[dateButton setSelected:YES];
				[selectedDates addObject:[dateButton date]];
			}
			
		} else {
			
			if (!rangeStartDate) {
				
				rangeStartDate = [[dateButton date] retain];
				[selectedDates addObject:rangeStartDate];
				[dateButton setSelected:YES];
				
			} else {
				
				if ([rangeStartDate isEqualToDate:[dateButton date]]) {
					
					[rangeStartDate release];
					rangeStartDate = nil;
					[rangeEndDate release];
					rangeEndDate = nil;
					[selectedDates removeAllObjects];
					[dateButton setSelected:NO];
					
				} else if (rangeEndDate) {
					
					if (rangeStartDate != [dateButton date]) {
						[rangeStartDate release];
					}
					if (rangeEndDate != [dateButton date]) {
						[rangeEndDate release];
					}
					
					rangeStartDate = [[dateButton date] retain];
					rangeEndDate = nil;
					[selectedDates removeAllObjects];
					[selectedDates addObject:rangeStartDate];
					[dateButton setSelected:YES];
					
				} else {
					
					if (rangeEndDate != [dateButton date]) {
						[rangeEndDate release];
					}
					
					rangeEndDate = [[dateButton date] retain];
					[selectedDates removeAllObjects];
					[selectedDates addObject:rangeEndDate];
					[dateButton setSelected:YES];
					[self addRangeDateObjects];
				}
				
				[self setUpCalendarWithDate:currentDate];
			}
			
		}
		
		if ([delegate respondsToSelector:@selector(picker:didSelectDate:)]) {
			[delegate picker:self didSelectDate:[selectedDates sortedArrayUsingSelector:@selector(compare:)]];
		}
	}
}

- (void)moveLastMonth:(id)sender
{
	NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
	[offsetComponents setMonth:-1];
	NSDate *date = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
	[self setUpCalendarWithDate:date];
}

- (void)moveNextMonth:(id)sender
{
	NSDateComponents *offsetComponents = [[[NSDateComponents alloc] init] autorelease];
	[offsetComponents setMonth:1];
	NSDate *date = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
	[self setUpCalendarWithDate:date];
}

- (void)setUpCalendarWithDate:(NSDate *)aDate
{
	if (currentDate != aDate) {
		[currentDate release];
	}
	currentDate = [aDate retain];
	NSDateComponents *components = [self getDateComponentsFromDate:currentDate];
	[components setDay:1];
	
	NSDate *date = [gregorian dateFromComponents:components];
	components = [self getDateComponentsFromDate:date];
	
	NSDateComponents *minusComponents = [[[NSDateComponents alloc] init] autorelease];
	[minusComponents setDay:-1];
	
	NSDate *lastManthDate = [gregorian dateByAddingComponents:minusComponents toDate:date options:0];
	NSDateComponents *lastManthDateComponents = [self getDateComponentsFromDate:lastManthDate];
	NSUInteger weekday = [lastManthDateComponents weekday];
	while (weekday != 7) {
		NSUInteger day = [lastManthDateComponents day];
		
		UICCalendarPickerDateButton *dateButton = (UICCalendarPickerDateButton *)[self viewWithTag:(7 * 0) + weekday];
		[self resetButtonAtributes:dateButton];
		
		[dateButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)day] forState:UIControlStateNormal];
		
		[dateButton setDate:lastManthDate];
		
		[dateButton setMonthout:YES];
		
		[dateButton setSelected:[selectedDates containsObject:lastManthDate]];
		
		if (minDate != nil
			&& [lastManthDate compare:minDate] != NSOrderedDescending && [lastManthDate compare:minDate] != NSOrderedSame) {
			[dateButton setOutOfRange:YES];
		}
		if (maxDate != nil
			&& [lastManthDate compare:maxDate] == NSOrderedDescending && [lastManthDate compare:maxDate] != NSOrderedSame) {
			[dateButton setOutOfRange:YES];
		}
		
		[self picker:self buttonForDate:dateButton];
		if ([dataSource respondsToSelector:@selector(picker:buttonForDate:)]) {
			[dataSource picker:self buttonForDate:dateButton];
		}
		
		lastManthDate = [gregorian dateByAddingComponents:minusComponents toDate:lastManthDate options:0];
		lastManthDateComponents = [self getDateComponentsFromDate:lastManthDate];
		weekday = [lastManthDateComponents weekday];
	}
	
	NSDateComponents *plusComponents = [[[NSDateComponents alloc] init] autorelease];
	[plusComponents setDay:1];
	
	NSInteger year = [components year];
	NSUInteger month = [components month];
	UILabel *monthLabel = (UILabel *)[self viewWithTag:UICCALENDAR_MONTH_LABEL_TAG];
	[monthLabel setText:[self picker:self textForYearMonth:currentDate]];
	if ([dataSource respondsToSelector:@selector(picker:textForYearMonth:)]) {
		[monthLabel setText:[dataSource picker:self textForYearMonth:currentDate]];
	}
    titleText = monthLabel.text;
	
	NSUInteger weekOfMonth = 0;
	
	do {
		
		NSUInteger day = [components day];
		NSUInteger weekday = [components weekday];
		
		UICCalendarPickerDateButton *dateButton = (UICCalendarPickerDateButton *)[self viewWithTag:(7 * weekOfMonth) + weekday];
		[self resetButtonAtributes:dateButton];
		
		[dateButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)day] forState:UIControlStateNormal];
		
		[dateButton setDate:date];
		
		[dateButton setToday:[date isEqualToDate:today]];
		[dateButton setNowday:[date isEqualToDate:nowday]];
		
        if (self.holidaylist && [self.holidaylist indexOfObject:date] != NSNotFound) {
            [dateButton setHoliday:YES];
        } else {
            [dateButton setHoliday:NO];
        }
		
		if ([CustomCalender checkHolidayWithIntYear:(int)year month:(int)month day:(int)day]) {
			[dateButton setHoliday:YES];
		}
		
		
		[dateButton setDayOfWeek:weekday];
		
		[dateButton setSelected:[selectedDates containsObject:date]];
		
		if (minDate != nil
			&& [date compare:minDate] != NSOrderedDescending && [date compare:minDate] != NSOrderedSame) {
			[dateButton setOutOfRange:YES];
		}
		if (maxDate != nil
			&& [date compare:maxDate] == NSOrderedDescending && [date compare:maxDate] != NSOrderedSame) {
			[dateButton setOutOfRange:YES];
		}
		
		[self picker:self buttonForDate:dateButton];
		if ([dataSource respondsToSelector:@selector(picker:buttonForDate:)]) {
			[dataSource picker:self buttonForDate:dateButton];
		}
		
		date = [gregorian dateByAddingComponents:plusComponents toDate:date options:0];
		components = [self getDateComponentsFromDate:date];
		
		if (weekday == 7) {
			weekOfMonth++;
		}
	} while (month == [components month]);
	
	weekday = [components weekday];
	while (weekday != 1) {
		NSUInteger day = [components day];
		
		UICCalendarPickerDateButton *dateButton = (UICCalendarPickerDateButton *)[self viewWithTag:(7 * weekOfMonth) + weekday];
		
		if (weekday == 7) {
			weekOfMonth++;
		}
		
		[self resetButtonAtributes:dateButton];
		
		[dateButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)day] forState:UIControlStateNormal];
		
		[dateButton setDate:date];
		
		[dateButton setMonthout:YES];
		
		[dateButton setSelected:[selectedDates containsObject:date]];
		
		if (minDate != nil
			&& [date compare:minDate] != NSOrderedDescending && [date compare:minDate] != NSOrderedSame) {
			[dateButton setOutOfRange:YES];
		}
		if (maxDate != nil
			&& [date compare:maxDate] == NSOrderedDescending && [date compare:maxDate] != NSOrderedSame) {
			[dateButton setOutOfRange:YES];
		}
		
		[self picker:self buttonForDate:dateButton];
		if ([dataSource respondsToSelector:@selector(picker:buttonForDate:)]) {
			[dataSource picker:self buttonForDate:dateButton];
		}
		
		date = [gregorian dateByAddingComponents:plusComponents toDate:date options:0];
		
		components = [self getDateComponentsFromDate:date];
		weekday = [components weekday];
	}
	
	for (int i = (int)((7 * weekOfMonth) + weekday); i <= 42; i++) {
		UICCalendarPickerDateButton *dateButton = (UICCalendarPickerDateButton *)[self viewWithTag:i];
		[self resetButtonAtributes:dateButton];
		
		[dateButton setTitle:nil forState:UIControlStateNormal];
		[dateButton setDate:nil];
		[self picker:self buttonForDate:dateButton];
		if ([dataSource respondsToSelector:@selector(picker:buttonForDate:)]) {
			[dataSource picker:self buttonForDate:dateButton];
		}
	}
}

- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date {
	return [gregorian components:(NSCalendarUnitDay | 
								  NSCalendarUnitWeekday | 
								  NSCalendarUnitMonth |
								  NSCalendarUnitYear) fromDate:date];
}

- (void)addRangeDateObjects
{
	NSDateComponents *offsetComponents;
	if ([rangeStartDate compare:rangeEndDate] == NSOrderedAscending) {
		offsetComponents = [[[NSDateComponents alloc] init] autorelease];
		[offsetComponents setDay:1];
	} else if ([rangeStartDate compare:rangeEndDate] == NSOrderedDescending) {
		offsetComponents = [[[NSDateComponents alloc] init] autorelease];
		[offsetComponents setDay:-1];
	} else {
		return;
	}
	
	NSDate *rangeDate = rangeStartDate;
	do {
		[selectedDates addObject:rangeDate];
		rangeDate = [gregorian dateByAddingComponents:offsetComponents toDate:rangeDate options:0];
	} while ([rangeDate compare:rangeEndDate] != NSOrderedSame);
}

//日本の祝日カレンダー取得
- (void)getHolidayCalendar
{
    //アラート開く
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:@"確認" message:@"カレンダーに祝日を表示するには、\n次に表示されるダウンロードサイトの【Download】ボタンより、\nダウンロードして下さい。"
                              delegate:self cancelButtonTitle:@"移動する" otherButtonTitles:@"キャンセル", nil];
    alert.tag = 0;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}
// アラートのボタンが押された時に呼ばれるデリゲート例文
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:
            switch (buttonIndex) {
                case 0:
                {
                    // １番目のボタンが押されたときの処理を記述する
                    // アラートの結果YESなら
                    // ブラウザ開く
                    NSURL *url = [NSURL URLWithString:HolidayCalendarURL];
                    [[UIApplication sharedApplication] openURL:url];
                    
                    // 注意書きをアラートで表示
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:@"確認" message:@"カレンダーが適用されるまでに時間がかかる場合があります。適用されない場合は「カレンダー」をご確認ください。"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alert.tag = 1;
                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                }break;
                case 1:
                    // ２番目のボタンが押されたときの処理を記述する
                    break;
            }
            break;
        case 1:
            // 祝日更新
//            [Global updateHoliday];
            break;
    }
}

// ボタンタップイベント（本日）
- (void)tapNowDayButton
{
    // 現在の日付取得
    self.today = nowday;
    [selectedDates removeAllObjects];
    [self addSelectedDate:self.today];
    if ([delegate respondsToSelector:@selector(picker:didSelectDate:)]) {
        [delegate picker:self didSelectDate:[selectedDates sortedArrayUsingSelector:@selector(compare:)]];
    }
}


@end
