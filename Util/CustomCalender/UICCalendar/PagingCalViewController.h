//
//  PagingCalViewController.h
//  OwnersSystem
//
//  Created by ws-GE0001 on 13/05/17.
//  Copyright (c) 2013年 fujitsu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PagingCalViewControllerDelegate <NSObject>

- (void) pagingCalViewDidEndDecelerating:(UIScrollView *)scrollView pageDiraction:(NSInteger)pageDirection;

@end

// Calendarのポップオーバーの種類
enum {
    CAL_OLD,
    CAL_NOW,
    CAL_NEW,
    CAL_ALL
};

@class UICCalendarPicker;
@interface PagingCalViewController : UIViewController <UIScrollViewDelegate, PagingCalViewControllerDelegate>
{
    id <PagingCalViewControllerDelegate>delegate;
    
    UICCalendarPicker *calendarPicker[CAL_ALL];
    NSDate *cacheDate;
}
@property (nonatomic, assign) id <PagingCalViewControllerDelegate>delegate;

@property (nonatomic) CGRect frame;
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic) CGRect bounds;
@property (nonatomic) CGSize contentSize;

// 現在表示している場所
@property (nonatomic) CGPoint currentViewPoint;

@property (strong, nonatomic) NSArray            *HolidayNSDatelist;


- (id)initDate:(NSDate *)_date holidays:(NSArray *)_holidays;

// 指定のカレンダーのポインタ取得
- (UICCalendarPicker *)getUICCalendarPickers:(NSInteger)selectnum;
// 中央のカレンダーのポインタ取得
- (UICCalendarPicker *)getUICCalendarPickerCenter;

// カレンダーを表示するナビゲーションバーに休日リスト取得ボタンを追加
- (void)setNaviBarToHolidaysButton;
// 本日ボタン追加(左に追加される)
- (void)setNaviBarToNowDayButton;

// 真ん中へスクロール
- (void)scrollToCenterViewAnimated:(BOOL)animated;
// 右へスクロール
- (void)scrollToRightViewAnimated:(BOOL)animated;
// 左へスクロール
- (void)scrollToLeftViewAnimated:(BOOL)animated;

- (void)setCaldelegate:(id)_id;

@end
