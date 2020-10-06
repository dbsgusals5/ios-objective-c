//
//  CustomCalender.h
//
//  Created by ALiMac10 on 2015/05/22.
//  Copyright (c) 2015年 Kamide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RegacySystemFontOfSize(s)        [UIFont fontWithName:@"HelveticaNeue" size:s]
#define RegacyBoldSystemFontOfSize(s)    [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define RegacyNullFontOfSize(s)          [UIFont fontWithName:@"" size:s]

@class CustomCalender;

// ポップオーバーを閉じた後に行われる処理
//    @param calender CustomCalender(自身)のインスタンス
typedef void (^CustomCalenderCompletion)(CustomCalender *calender, NSDate *selectDay);

/*---------------------------------------------------------------------------------------------------
 CustomCalender
 ---------------------------------------------------------------------------------------------------*/
@interface CustomCalender : NSObject

// カレンダーのポップアップの作成
+ (CustomCalender *)createCalendarWithTargetTextField:(UITextField *)target
											   format:(NSString *)format
											 initDate:(NSDate *)initDate
							 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections;

// カレンダーのポップアップの作成 (閉じた後の処理指定可)
+ (CustomCalender *)createCalendarWithTargetTextField:(UITextField *)target
											   format:(NSString *)format
											 initDate:(NSDate *)initDate
							 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
										   completion:(CustomCalenderCompletion)completion;
// NSStringをNSDateに変換する
+ (NSDate *)createNSDateFromString:(NSString *)dateString format:(NSString *)format;

// NSDateをNSStringに変換する
+ (NSString *)createDateStringFromNSDate:(NSDate *)date format:(NSString *)format;

// 月の日数を取得する
+ (int)getDaysWithIntYear:(int)year month:(int)month;
+ (int)getDaysWithStringYear:(NSString *)year month:(NSString *)month;

// 曜日を取得する
+ (NSString *)getWeekDayStringWithIntYear:(int)year month:(int)month day:(int)day;
+ (NSString *)getWeekDayStringWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day;
+ (int)getWeekDayNumWithIntYear:(int)year month:(int)month day:(int)day;
+ (int)getWeekDayNumWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

// 祝日判定
+ (BOOL)checkHolidayWithIntYear:(int)year month:(int)month day:(int)day;
+ (BOOL)checkHolidayWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

// 祝日名取得
+ (NSString *)getHolidayNameWithIntYear:(int)year month:(int)month day:(int)day;
+ (NSString *)getHolidayNameWithStringYear:(NSString *)year month:(NSString *)month day:(NSString *)day;

@end
