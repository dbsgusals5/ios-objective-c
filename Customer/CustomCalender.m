//
//  CustomCalender.m
//
//  Created by ALiMac10 on 2015/05/22.
//  Copyright (c) 2015年 Kamide. All rights reserved.
//

#import "CustomCalender.h"
#import "PagingCalViewController.h"
#import "UIPopoverPresentationController+Utilities.h"
#import "AppDelegate.h"

@interface CustomCalender () <UIPopoverPresentationControllerDelegate>

@property (nonatomic, retain) PagingCalViewController *pagingCalViewController;
@property (nonatomic, retain) UIPopoverPresentationController *calendarPop;

// 日付を入れる対象のテキスト
@property (nonatomic, weak) UITextField *targetTextField;
// 取得する日付のフォーマット
@property (nonatomic, strong) NSString *dateFormat;
// ポップオーバーが閉じた後に行う処理
@property (nonatomic, copy) CustomCalenderCompletion calenderCompletion;

// 自動解放されるのを防ぐため、自身の強参照を持つ
@property (nonatomic, strong) CustomCalender *strongSelf;

@end

@implementation CustomCalender

// 枠線のデフォルト設定
static const CGFloat defaultBorderWidth  = 2.0f;
static const CGFloat defaultBorderRadius = 10.0f;
+ (UIColor *)defaultBorderColor {
	return [UIColor colorWithRed:0.098f green:0.098f blue:0.439f alpha:1.0f];
}

- (void)dealloc
{
	_strongSelf = nil;
	_dateFormat = nil;
	_calenderCompletion = nil;
	_calendarPop.delegate = nil;
}

/**
 @brief カレンダーのポップアップの作成
 @param	target (UITextField *)						        ポップオーバーのバインドするテキスト　且つ　選択された日付を入れるテキスト
 @param	format (NSString *)									取得する日付のフォーマット　@"yyyy/MM/dd"など
 @param	initDate (NSDate *)									最初に選択されている日付（ポップオーバー表示時に表示する日付）
 @param	arrowDirections (UIPopoverArrowDirection)	        ポップオーバーの吹き出しの方向
 
 @return カレンダーのインスタンス
 */
+ (CustomCalender *)createCalendarWithTargetTextField:(UITextField *)target
											   format:(NSString *)format
											 initDate:(NSDate *)initDate
							 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
{
	CustomCalender *calender = [[CustomCalender new] init];
	
	// 初期選択の日付が指定されているならその日付、そうでないなら本日の日付でPagingCalViewControllerを作成
	if (initDate) {
		calender.pagingCalViewController = [[PagingCalViewController new] initDate:initDate
																		  holidays:nil];
	} else {
		calender.pagingCalViewController = [[PagingCalViewController new] initDate:[NSDate dateWithTimeIntervalSinceNow:0]
																		  holidays:nil];
	}
	
	calender.dateFormat = format;
	calender.targetTextField = target;
	
	[calender.pagingCalViewController setCaldelegate:calender];
	
	calender.pagingCalViewController.title = @"日付選択";
	
	calender.pagingCalViewController.preferredContentSize = calender.pagingCalViewController.view.frame.size;
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }
    
    calender.calendarPop = [UIPopoverPresentationController presentPopoverController:calender.pagingCalViewController
                                                                              inView:calender.targetTextField
                                                                parentViewController:rootViewController];
    
    [calender.calendarPop setFrameBorderWithBorderColor:[CustomCalender defaultBorderColor] borderWidth:defaultBorderWidth];
    calender.calendarPop.presentedViewController.view.layer.cornerRadius = defaultBorderRadius;
    calender.calendarPop.delegate = calender;
	
	calender.strongSelf = calender;
	calender.calenderCompletion = nil;
	
	return calender;
}
/**
 @brief カレンダーのポップアップの作成 (閉じた後の処理指定可)
 @param	target	(UITextField *)						        ポップオーバーのバインドするテキスト　且つ　選択された日付を入れるテキスト
 @param	format (NSString *)									取得する日付のフォーマット　@"yyyy/MM/dd"など
 @param	initDate (NSDate *)									最初に選択されている日付（ポップオーバー表示時に表示する日付）
 @param	arrowDirections (UIPopoverArrowDirection)	        ポップオーバーの吹き出しの方向
 @param	completion (CustomCalenderCompletion)				ポップオーバーを閉じた後に行われる処理
 
 @return カレンダーのインスタンス
 */
+ (CustomCalender *)createCalendarWithTargetTextField:(UITextField *)target
											   format:(NSString *)format
											 initDate:(NSDate *)initDate
							 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
										   completion:(CustomCalenderCompletion)completion
{
	CustomCalender *calender = [CustomCalender createCalendarWithTargetTextField:target
																		  format:format
																		initDate:initDate
														permittedArrowDirections:arrowDirections];
	calender.calenderCompletion = completion;
	
	return calender;
}
/**
 @brief NSStringをNSDateに変換する
 @param	dateString (NSString *)	変換する日付(NSString型)
 @param	format (NSString *)		日付のフォーマット　@"yyyy/MM/dd HH:mm:ss"など
 
 @return NSDate型の日付データ
 */
+ (NSDate *)createNSDateFromString:(NSString *)dateString format:(NSString *)format
{
	NSDate *date;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	date = [formatter dateFromString:dateString];
	
	return date;
}
/**
 @brief NSDateをNSStringに変換する
 @param	date (NSDate *)		変換する日付(NSDate型)
 @param	format (NSString *)	日付のフォーマット　@"yyyy/MM/dd HH:mm:ss"など
 
 @return NSString型の日付データ
 */
+ (NSString *)createDateStringFromNSDate:(NSDate *)date format:(NSString *)format
{
	NSString *dateString;
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	dateString = [outputFormatter stringFromDate:date];
	
	return dateString;
}
/**
 @brief 月の日数を取得する
 @param	year (NSString *)	月
 @param	month (NSString *)	年
 */
+ (int)getDaysWithStringYear:(NSString *)year month:(NSString *)month {
	return [CustomCalender getDaysWithIntYear:(int)[year integerValue] month:(int)[month integerValue]];
}
/**
 @brief 月の日数を取得する
 @param	year (int)	月
 @param	month (int)	年
 */
+ (int)getDaysWithIntYear:(int)year month:(int)month
{
	NSString *currentYearMonth = [NSString stringWithFormat:@"%d/%d", year, month];
	NSDate *today = [CustomCalender createNSDateFromString:currentYearMonth format:@"yyyy/MM"];
	NSCalendar *c = [NSCalendar currentCalendar];
	NSRange days = [c rangeOfUnit:NSCalendarUnitDay
						   inUnit:NSCalendarUnitMonth
						  forDate:today];
	return (int)days.length;
}
/**
 @brief 曜日を取得する
 @param	year (NSString *)	月
 @param	month (NSString *)	年
 @param	day (NSString *)	日
 */
+ (NSString *)getWeekDayStringWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
	return [CustomCalender getWeekDayStringWithIntYear:(int)[year integerValue]
												 month:(int)[month integerValue]
												   day:(int)[day integerValue]];
}
/**
 @brief 曜日を取得する
 @param	year (int)	月
 @param	month (int)	年
 @param	day (int)	日
 */
+ (NSString *)getWeekDayStringWithIntYear:(int)year month:(int)month day:(int)day
{
	NSString *dayString = [NSString stringWithFormat:@"%d/%d/%d", year, month, day];
	NSDate *date = [CustomCalender createNSDateFromString:dayString format:@"yyyy/MM/dd"];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday
                                          fromDate:date];
	
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja"];
	
    // comps.weekdayは 1-7の値が取得できるので-1する
    NSString *weekDayStr = df.shortWeekdaySymbols[comps.weekday-1];
	
	return weekDayStr;
}
/**
 @brief 曜日を取得する(数値)
 @param	year (NSString *)	年
 @param	month (NSString *)	月
 @param	day (NSString *)	日
 */
+ (int)getWeekDayNumWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day {
	return [CustomCalender getWeekDayNumWithIntYear:(int)[year integerValue]
											  month:(int)[month integerValue]
												day:(int)[day integerValue]];
}
/**
 @brief 曜日を取得する(数値)
 @param	year (int)	年
 @param	month (int)	月
 @param	day (int)	日
 */
+ (int)getWeekDayNumWithIntYear:(int)year month:(int)month day:(int)day
{
	NSString *dayString = [NSString stringWithFormat:@"%d/%d/%d", year, month, day];
	NSDate *date = [CustomCalender createNSDateFromString:dayString format:@"yyyy/MM/dd"];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday
                                          fromDate:date];
	
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja"];
	
    // comps.weekdayは 1-7の値が取得できるので-1する
	return (int)comps.weekday - 1;
}
/**
 @brief 春分の日の取得(3月)
 @param	year (int)	年
 */
+ (int)getSyunbunWithYear:(int)year
{
    int dd;
    if (year <= 1947) {
        dd = 99;
    } else if (year <= 1979) {
        dd = (int)(20.8357 + (0.242194 * (year - 1980)) - (int)((year - 1983) / 4));
    } else if (year <= 2099) {
        dd = (int)(20.8431 + (0.242194 * (year - 1980)) - (int)((year - 1980) / 4));
    } else if (year <= 2150) {
        dd = (int)(21.851 + (0.242194 * (year - 1980)) - (int)((year - 1980) / 4));
    } else {
        dd = 99;
    }
    return dd;
}
/**
 @brief 秋分の日の取得(9月)
 @param	year (int)	年
 */
+ (int)getSyubunWithYear:(int)year
{
    int dd;
    if (year <= 1947) {
        dd = 99;
    } else if (year <= 1979) {
        dd = (int)(23.2588 + (0.242194 * (year - 1980)) - (int)((year - 1983) / 4));
    } else if (year <= 2099) {
        dd = (int)(23.2488 + (0.242194 * (year - 1980)) - (int)((year - 1980) / 4));
    } else if (year <= 2150) {
        dd = (int)(24.2488 + (0.242194 * (year - 1980)) - (int)((year - 1980) / 4));
    } else {
        dd = 99;
    }
    return dd;
}
/**
 @brief 指定日が月の何週目にあたるか計算
 @param	day (int)	日
 */
+ (int)getNumOfWeekWithDay:(int)day {
	return (day - 1) / 7 + 1;
}
/**
 @brief 祝日名を取得
 @param	year (int)	年
 @param	month (int)	月
 @param	day (int)	日
 */
+ (NSString *)getHolidayNameWithIntYear:(int)year month:(int)month day:(int)day
{
	return [CustomCalender getHolidayNameWithStringYear:[NSString stringWithFormat:@"%d", year]
												  month:[NSString stringWithFormat:@"%d", month]
													day:[NSString stringWithFormat:@"%d", day]];
}
/**
 @brief 祝日名を取得
 @param	year (NSString *)	年
 @param	month (NSString *)	月
 @param	day (NSString *)	日
 */
+ (NSString *)getHolidayNameWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
	NSString *result = [CustomCalender HolidayNameWithStringYear:year
														   month:month
															 day:day];
	
	int y = (int)[year integerValue];
	int m = (int)[month integerValue];
	int d = (int)[day integerValue];
	
	// 祝日ではなく、前回の日曜が休日の場合は振替休日
	if (!([result length] > 0)) {
		
		int sunday = d - [CustomCalender getWeekDayNumWithIntYear:y month:m day:d];
		
		if ( [CustomCalender HolidayWithStringYear:year month:month day:[NSString stringWithFormat:@"%d", sunday]]) {
			
			if (y < 2007) {
				
				// 2007年より前は最初の月曜を振替休日とする
				if (d == sunday + 1) {
					result = @"振替休日";
				}
				
			} else {
				
				// 2007年以降は「その日後においてその日に最も近い「国民の祝日」でない日」が振替休日
				BOOL isWeekday = NO;
				// 指定日から前回の日曜までの間に振替休日にできる平日がないかチェック
				int weekDay = [CustomCalender getWeekDayNumWithIntYear:y month:m day:d];	// 指定日の曜日取得
				for (int i=1; i < weekDay; i++) {
					
					if (![CustomCalender HolidayWithStringYear:year month:month day:[NSString stringWithFormat:@"%d", d - i]]) {
						isWeekday = YES;
					}
				}
				
				// 最初の平日だった場合は振替休日とする
				if (!isWeekday) {
					result = @"振替休日";
				}
			}
		}
	}
	
	return result;
}
/**
 @brief 祝日かを判定
 @param	year (int)	年
 @param	month (int)	月
 @param	day (int)	日
 */
+ (BOOL)checkHolidayWithIntYear:(int)year month:(int)month day:(int)day
{
	return [CustomCalender checkHolidayWithStringYear:[NSString stringWithFormat:@"%d", year]
												month:[NSString stringWithFormat:@"%d", month]
												  day:[NSString stringWithFormat:@"%d", day]];
}
/**
 @brief 祝日かを判定
 @param	year (NSString *)	年
 @param	month (NSString *)	月
 @param	day (NSString *)	日
 */
+ (BOOL)checkHolidayWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
	BOOL result = [CustomCalender HolidayWithStringYear:year
												  month:month
													day:day];
	
	int y = (int)[year integerValue];
	int m = (int)[month integerValue];
	int d = (int)[day integerValue];
	
	// 祝日ではなく、前回の日曜が休日の場合は振替休日
	if (!result) {
		
		int sunday = d - [CustomCalender getWeekDayNumWithIntYear:y month:m day:d];
		
		if ( [CustomCalender HolidayWithStringYear:year month:month day:[NSString stringWithFormat:@"%d", sunday]]) {
			
			if (y < 2007) {
				
				// 2007年より前は最初の月曜を振替休日とする
				if (d == sunday + 1) {
					result = YES;
				}
				
			} else {
				
				// 2007年以降は「その日後においてその日に最も近い「国民の祝日」でない日」が振替休日
				BOOL isWeekday = NO;
				// 指定日から前回の日曜までの間に振替休日にできる平日がないかチェック
				int weekDay = [CustomCalender getWeekDayNumWithIntYear:y month:m day:d];	// 指定日の曜日取得
				for (int i=1; i < weekDay; i++) {
					
					if (![CustomCalender HolidayWithStringYear:year month:month day:[NSString stringWithFormat:@"%d", d - i]]) {
						isWeekday = YES;
					}
				}
				
				// 最初の平日だった場合は振替休日とする
				if (!isWeekday) {
					result = YES;
				}
			}
		}
	}
	
	return result;
}
/**
 @brief 祝日かを判定(土,日,振替休日は非考慮)
 @param	year (NSString *)	年
 @param	month (NSString *)	月
 @param	day (NSString *)	日
 */
+ (BOOL)HolidayWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
	BOOL result = NO;
	int y = (int)[year integerValue];
	int m = (int)[month integerValue];
	int d = (int)[day integerValue];
	int w = [CustomCalender getWeekDayNumWithIntYear:y month:m day:d];
	
    int c = [CustomCalender getNumOfWeekWithDay:d];
	
	// 秋分の日
	if (m == 9) {
		if ([CustomCalender getSyubunWithYear:y] == d) {
			result = YES;
		}
	}
	// 春分の日
	if (m == 3) {
		if ([CustomCalender getSyunbunWithYear:y] == d) {
			result = YES;
		}
	}
	
	if (m == 1 && d == 1) {
		result = YES;	// 元日
	} else if ((y >= 1949 && y < 2000) &&  m == 1 && d == 15) {
		// 1949-1999	1月15日 成人の日
		result = YES;
	} else if ((y >= 2000) &&  m == 1 && w == 1 && c == 2) {
		// 2000-		1月第2月曜日 成人の日
		result = YES;
	} else if (y >= 1967 && m == 2 && d == 11) {
		// 1967-		2月11日 建国記念日
		result = YES;
	} else if (y == 1989 && m == 2 && d == 24) {
		// 1989			2月24日 昭和天皇の大喪の礼
		result = YES;
	}  else if (y == 1959 && m == 4 && d == 10) {
		// 1959			4月10日 皇太子明仁親王の結婚の儀
		result = YES;
	} else if (y >= 1949 && y < 1989 && m == 4 && d == 29) {
		// 1949-1988	4月29日 天皇誕生日
		result = YES;
	} else if (y >= 1989 && m == 4 && d == 29) {
		// 2007-		4月29日 昭和の日
		if ( y >= 2007) {
			result = YES;
		} else {
			// 1989-2006	4月29日 緑の日
			result = YES;
		}
	} else if (y >= 1949 && m == 5 && d == 3) {
		// 1949-		5月3日 憲法記念日
		result = YES;
	} else if (y >= 1986 && m == 5 && d == 4) {
		// 2007-		5月4日 緑の日
		if ( y >= 2007) {
			result = YES;
		} else {
			// 1986-2006	5月4日 国民の休日
			result = YES;
		}
	} else if (y >= 1949 && m == 5 && d == 5) {
		// 1949-		5月5日 こどもの日
		result = YES;
	} else if (y == 1993 && m == 6 && d == 9) {
		// 1993-		6月9日 皇太子徳仁親王の結婚の儀
		result = YES;
	} else if (y >= 1996  && y < 2003  && m == 7 && d == 20) {
		// 1949-2002	7月20日 海の日
		result = YES;
	} else if (y >= 2003 && m == 7 && w == 1 && c == 3) {
		// 2003-		7月第3月曜 海の日
		result = YES;
	} else if (y >= 2016 && m == 8 && d == 11) {
		// 2016-		8月11日 山の日
		result = YES;
	} else if (y >= 1966  && y < 2003  && m == 9 && d == 15) {
		// 1966-2002	9月15日 敬老の日
		result = YES;
	} else if (y >= 2003 && m == 9 && w == 1 && c == 3) {
		// 2003-		9月第3月曜 敬老の日
		result = YES;
	} else if (y >= 1966  && y < 2003  && m == 10 && d == 10) {
		// 1966-2002	10月10日 体育の日
		result = YES;
	} else if (y >= 2003 && m == 10 && w == 1 && c == 2) {
		// 2003-		10月第2月曜 体育の日
		result = YES;
	} else if (y >= 1948 && m == 11 && d == 3) {
		// 1948-		11月3日 文化の日
		result = YES;
	} else if (y == 1990 && m == 11 && d == 12) {
		// 1990			11月12日 即位礼正殿の儀
		result = YES;
	} else if (y >= 1948 && m == 11 && d == 23) {
		// 1948-		11月23日 勤労感謝の日
		result = YES;
	} else if (y >= 1989 && m == 12 && d == 23) {
		// 1989-		11月23日 天皇誕生日
		result = YES;
	} else if (y >= 2003 &&
			   m == 9 &&
			   [CustomCalender getNumOfWeekWithDay:d - 1] == 3
			   && w - 1 == 1 &&
			   (d + 1) == [CustomCalender getSyubunWithYear:y]) {
		// 2003- 9月、前日が第3月曜日、翌日が秋分の日 国民の休日
		result = YES;
	} else if (m == 3 && d == [CustomCalender getSyunbunWithYear:y]) {
		// 春分の日
		result = YES;
	} else if (m == 9 && d == [CustomCalender getSyubunWithYear:y]) {
		// 秋分の日
		result = YES;
	}
	
	return result;
}
/**
 @brief 祝日名を取得(振替休日非考慮)
 @param	year (NSString *)	年
 @param	month (NSString *)	月
 @param	day (NSString *)	日
 */
+ (NSString *)HolidayNameWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day
{
	NSString *result = @"";
	int y = (int)[year integerValue];
	int m = (int)[month integerValue];
	int d = (int)[day integerValue];
	int w = [CustomCalender getWeekDayNumWithIntYear:y month:m day:d];
	
    int c = [CustomCalender getNumOfWeekWithDay:d];
	
	// 秋分の日
	if (m == 9) {
		if ([CustomCalender getSyubunWithYear:y] == d) {
			result = @"秋分の日";
		}
	}
	// 春分の日
	if (m == 3) {
		if ([CustomCalender getSyunbunWithYear:y] == d) {
			result = @"春分の日";
		}
	}
	
	if (m == 1 && d == 1) {
		result = @"元日";	// 元日
	} else if ((y >= 1949 && y < 2000) &&  m == 1 && d == 15) {
		// 1949-1999	1月15日 成人の日
		result = @"成人の日";
	} else if ((y >= 2000) &&  m == 1 && w == 1 && c == 2) {
		// 2000-		1月第2月曜日 成人の日
		result = @"成人の日";
	} else if (y >= 1967 && m == 2 && d == 11) {
		// 1967-		2月11日 建国記念日
		result = @"建国記念日";
	} else if (y == 1989 && m == 2 && d == 24) {
		// 1989			2月24日 昭和天皇の大喪の礼
		result = @"昭和天皇の大喪の礼";
	}  else if (y == 1959 && m == 4 && d == 10) {
		// 1959			4月10日 皇太子明仁親王の結婚の儀
		result = @"皇太子明仁親王の結婚の儀";
	} else if (y >= 1949 && y < 1989 && m == 4 && d == 29) {
		// 1949-1988	4月29日 天皇誕生日
		result = @"天皇誕生日";
	} else if (y >= 1989 && m == 4 && d == 29) {
		// 2007-		4月29日 昭和の日
		if ( y >= 2007) {
			result = @"昭和の日";
		} else {
			// 1989-2006	4月29日 緑の日
			result = @"緑の日";
		}
	} else if (y >= 1949 && m == 5 && d == 3) {
		// 1949-		5月3日 憲法記念日
		result = @"憲法記念日";
	} else if (y >= 1986 && m == 5 && d == 4) {
		// 2007-		5月4日 緑の日
		if ( y >= 2007) {
			result = @"緑の日";
		} else {
			// 1986-2006	5月4日 国民の休日
			result = @"国民の休日";
		}
	} else if (y >= 1949 && m == 5 && d == 5) {
		// 1949-		5月5日 こどもの日
		result = @"こどもの日";
	} else if (y == 1993 && m == 6 && d == 9) {
		// 1993			6月9日 皇太子徳仁親王の結婚の儀
		result = @"皇太子徳仁親王の結婚の儀";
	} else if (y >= 1996  && y < 2003  && m == 7 && d == 20) {
		// 1949-2002	7月20日 海の日
		result = @"海の日";
	} else if (y >= 2003 && m == 7 && w == 1 && c == 3) {
		// 2003-		7月第3月曜 海の日
		result = @"海の日";
	} else if (y >= 2016 && m == 8 && d == 11) {
		// 2016-		8月11日 山の日
		result = @"山の日";
	} else if (y >= 1966  && y < 2003  && m == 9 && d == 15) {
		// 1966-2002	9月15日 敬老の日
		result = @"敬老の日";
	} else if (y >= 2003 && m == 9 && w == 1 && c == 3) {
		// 2003-		9月第3月曜 敬老の日
		result = @"敬老の日";
	} else if (y >= 1966  && y < 2003  && m == 10 && d == 10) {
		// 1966-2002	10月10日 体育の日
		result = @"体育の日";
	} else if (y >= 2003 && m == 10 && w == 1 && c == 2) {
		// 2003-		10月第2月曜 体育の日
		result = @"体育の日";
	} else if (y >= 1948 && m == 11 && d == 3) {
		// 1948-		11月3日 文化の日
		result = @"文化の日";
	} else if (y == 1990 && m == 11 && d == 12) {
		// 1990			11月12日 即位礼正殿の儀
		result = @"即位礼正殿の儀";
	} else if (y >= 1948 && m == 11 && d == 23) {
		// 1948-		11月23日 勤労感謝の日
		result = @"勤労感謝の日";
	} else if (y >= 1989 && m == 12 && d == 23) {
		// 1989-		11月23日 天皇誕生日
		result = @"天皇誕生日";
	} else if (y >= 2003 &&
			   m == 9 &&
			   [CustomCalender getNumOfWeekWithDay:d - 1] == 3 &&
			   w - 1 == 1 &&
			   (d + 1) == [CustomCalender getSyubunWithYear:y]) {
		// 2003- 9月、前日が第3月曜日、翌日が秋分の日 国民の休日
		result = @"国民の休日";
	} else if (m == 3 && d == [CustomCalender getSyunbunWithYear:y]) {
		// 春分の日
		result = @"春分の日";
	} else if (m == 9 && d == [CustomCalender getSyubunWithYear:y]) {
		// 秋分の日
		result = @"秋分の日";
	}
	
	return result;
}
/*---------------------------------------------------------------------------------------------------
 デリゲート
 ---------------------------------------------------------------------------------------------------*/
// 選択された日付をテキストに入れてポップオーバーを閉じる
- (void)picker:(UICCalendarPicker *)picker didSelectDate:(NSArray *)selectedDate
{
	[_calendarPop dismissPopoverAnimated:YES];
	
	if ([selectedDate count] > 0) {
		
		NSDate *selectDay = [selectedDate objectAtIndex:0];
		
		_targetTextField.text = [CustomCalender createDateStringFromNSDate:selectDay format:_dateFormat];
	}
	
	if (_calenderCompletion) {
		
		NSDate *selectDay = nil;
		
		if ([selectedDate count] > 0) {
			selectDay = [selectedDate objectAtIndex:0];
		}
		
		_calenderCompletion(self, selectDay);
		_calenderCompletion = nil;
	}
	_strongSelf = nil;
}
// 閉じた後に呼び出される
- (void)popoverControllerDidDismissPopover:popoverController
{
	if (_calenderCompletion) {
		
		_calenderCompletion(self, nil);
		_calenderCompletion = nil;
	}
	_strongSelf = nil;
}

@end
