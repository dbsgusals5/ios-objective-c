//
//  PagingCalViewController.m
//  OwnersSystem
//
//  Created by ws-GE0001 on 13/05/17.
//  Copyright (c) 2013年 fujitsu. All rights reserved.
//
// TODO:2013/05/22 カレンダー専用に改修、統合を非考慮

#import "PagingCalViewController.h"
#import "UICCalendarPicker.h"
#import "UICCalendarPickerDateButton.h"
#import "CustomCalender.h"

@interface PagingCalViewController () {
	
    UILabel *popTitle;
}

@end

@implementation PagingCalViewController

@synthesize delegate = _delegate;

@synthesize frame = _frame;
@synthesize scrollView = _scrollView;
@synthesize bounds = _bounds;
@synthesize contentSize = _contentSize;
@synthesize currentViewPoint = _currentViewPoint;


- (id)initDate:(NSDate *)_date holidays:(NSArray *)_holidays
{
    self = [super init];
    if (self) {
        //                                                                                                                                                                                                                                                                カレンダー作成3つ作る(先月、今月、来月)　今月以外delegateは不要
        for (int i = 0; i<CAL_ALL; i++) {
            calendarPicker[i] = [[UICCalendarPicker alloc] initWithSize:UICCalendarPickerSizeIPadMedium];
            calendarPicker[i].today = _date;
            calendarPicker[i].nowday = [NSDate date];
        }
        
        self.HolidayNSDatelist = _holidays;
        [self calendarMonthSet:_date];
        //_frame = calendarPicker[CAL_NOW].bounds;
        _frame = CGRectMake(0, 0.0f, 575, 428);
        
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.frame = calendarPicker[CAL_NOW].bounds;
    self.view.frame = CGRectMake(0, 0, 575, 428);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:_frame];
    //_scrollView.frame = CGRectMake(0, 0, 575, 448);
    self.bounds = self.view.bounds;
    self.contentSize = CGSizeMake(_frame.size.width * 3, _frame.size.height);
    //self.view = _scrollView;
    
    [self.view addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.bounces = NO;
    // 隣のページも表示する
    _scrollView.clipsToBounds = NO;
    // 垂直、水平方向のスクロールインジケータを非表示にする
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    // オーバースクロール禁止
    _scrollView.bounces = NO;
    
    for (int i = 0; i<CAL_ALL; i++) {
        CGRect tmpRect = calendarPicker[i].bounds;
        tmpRect.origin.x = calendarPicker[i].bounds.size.width * i;
        calendarPicker[i].frame = tmpRect;
    }
    [self.scrollView addSubview:calendarPicker[CAL_NOW]];
    [self.scrollView addSubview:calendarPicker[CAL_OLD]];
    [self.scrollView addSubview:calendarPicker[CAL_NEW]];
    // 年月とボタンのUIセット
    UIImage *popBG = [UIImage imageNamed:@"uiccalendar_background_header"];
    UIImageView *popBgImageView = [[UIImageView alloc] initWithImage:popBG];	// 背景画像
    popBgImageView.frame = popBgImageView.bounds;
    popBgImageView.userInteractionEnabled = YES;
    popTitle = [[UILabel alloc] init];	// ラベル
    popTitle.textAlignment = NSTextAlignmentCenter;
    popTitle.backgroundColor = [UIColor clearColor];
    [popTitle setFont:RegacyBoldSystemFontOfSize(18.0f)];
    popTitle.text = @"12234年12月";
    popTitle.textColor = [UIColor colorWithRed:77.0f/255.0f green:77.0f/255.0f blue:77.0f/255.0f alpha:1.0f];
    [popTitle sizeToFit];
    popTitle.text = calendarPicker[CAL_NOW].titleText;
    popTitle.frame = CGRectMake(popBgImageView.frame.size.width/2-popTitle.frame.size.width/2,
                                popBgImageView.frame.size.height/2-popTitle.frame.size.height/2,
                                popTitle.frame.size.width, popTitle.frame.size.height);
    [popBgImageView addSubview:popTitle];
    
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
    [prevButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_left_arrow"] forState:UIControlStateNormal];
    [prevButton setFrame:calendarPicker[CAL_NOW].prevButton.frame];
    calendarPicker[CAL_NOW].prevButton.hidden = YES;
    [prevButton setShowsTouchWhenHighlighted:NO];
    [prevButton addTarget:self action:@selector(popupCalendarMonthButton:) forControlEvents:UIControlEventTouchUpInside];
    prevButton.tag = -1;
    [popBgImageView addSubview:prevButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
    [nextButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_right_arrow"] forState:UIControlStateNormal];
    [nextButton setFrame:calendarPicker[CAL_NOW].nextButton.frame];
    calendarPicker[CAL_NOW].nextButton.hidden = YES;
    [nextButton setShowsTouchWhenHighlighted:NO];
    [nextButton addTarget:self action:@selector(popupCalendarMonthButton:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 1;
    [popBgImageView addSubview:nextButton];
    [self.view addSubview:popBgImageView];
    
    UIButton *prevYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevYearButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
    [prevYearButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_left_year_arrow"] forState:UIControlStateNormal];
    [prevYearButton setFrame:calendarPicker[CAL_NOW].prevYearButton.frame];
    calendarPicker[CAL_NOW].prevYearButton.hidden = YES;
    [prevYearButton setShowsTouchWhenHighlighted:NO];
    [prevYearButton addTarget:self action:@selector(popupCalendarYearButton:) forControlEvents:UIControlEventTouchUpInside];
    prevYearButton.tag = -1;
    [popBgImageView addSubview:prevYearButton];
    
    UIButton *nextYearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextYearButton.exclusiveTouch = YES;  // 複数ボタンの同時押し防止
    [nextYearButton setBackgroundImage:[UIImage imageNamed:@"uiccalendar_right_year_arrow"] forState:UIControlStateNormal];
    [nextYearButton setFrame:calendarPicker[CAL_NOW].nextYearButton.frame];
    calendarPicker[CAL_NOW].nextYearButton.hidden = YES;
    [nextYearButton setShowsTouchWhenHighlighted:NO];
    [nextYearButton addTarget:self action:@selector(popupCalendarYearButton:) forControlEvents:UIControlEventTouchUpInside];
    nextYearButton.tag = 1;
    [popBgImageView addSubview:nextYearButton];
    [self.view addSubview:popBgImageView];

    // 中央にスクロール
    [self scrollToCenterViewAnimated:NO];
}

- (void)dealloc
{
    for (int i=0; i<CAL_ALL; i++) {
        calendarPicker[i] = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate
// ドラックを開始した時
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

// ドラックが終了した時
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSInteger direction = [self directionJudgment:scrollView];
        
        if ([self.delegate respondsToSelector:@selector(pagingCalViewDidEndDecelerating:pageDiraction:)]) {
            [self.delegate pagingCalViewDidEndDecelerating:_scrollView pageDiraction:direction];
        }
    }
}

// スクロール(自動調節)が開始した時
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

// スクロール(自動調節)が停止した時
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    NSInteger direction = [self directionJudgment:scrollView];
    
    if ([self.delegate respondsToSelector:@selector(pagingCalViewDidEndDecelerating:pageDiraction:)]) {
        [self.delegate pagingCalViewDidEndDecelerating:_scrollView pageDiraction:direction];
    }
}

// setContentOffsetのアニメーション終了時
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger direction = [self directionJudgment:scrollView];
    if ([self.delegate respondsToSelector:@selector(pagingCalViewDidEndDecelerating:pageDiraction:)]) {
        [self.delegate pagingCalViewDidEndDecelerating:_scrollView pageDiraction:direction];
    }
}

#pragma mark - スクロール位置判定系
// どっちに移動したかの判定
- (NSInteger)directionJudgment:(UIScrollView *)scrollView
{
    // 移動距離
    float move = _scrollView.contentOffset.x - _currentViewPoint.x;
    // 移動ページ数
    int moving = (move / _scrollView.bounds.size.width);
    
    return moving;
}

// 真ん中へスクロール
- (void)scrollToCenterViewAnimated:(BOOL)animated
{
    // 真ん中へスクロール
    [_scrollView setContentOffset:CGPointMake(_bounds.size.width * 1, 0) animated:animated];
    // 現在表示している場所を更新
    _currentViewPoint = _scrollView.contentOffset;
}
// 右へスクロール
- (void)scrollToRightViewAnimated:(BOOL)animated
//          completionToCenter:(BOOL)toCenter
{
    if (_scrollView.contentOffset.x - _currentViewPoint.x > 0)
    {
        return;
    }
    // 右へスクロール
    [_scrollView setContentOffset:CGPointMake(_bounds.size.width * 2, 0) animated:animated];
    // 現在表示している場所を更新
//    currentViewPoint = _scrollView.contentOffset;
}
// 左へスクロール
- (void)scrollToLeftViewAnimated:(BOOL)animated
{
    if (_scrollView.contentOffset.x - _currentViewPoint.x < 0) {
        return;
    }
    // 左へスクロール
    [_scrollView setContentOffset:CGPointMake(_bounds.size.width * 0, 0) animated:animated];
    // 現在表示している場所を更新
//    currentViewPoint = _scrollView.contentOffset;
}

#pragma - ポインタ
// 指定のカレンダーのポインタ取得
- (UICCalendarPicker *)getUICCalendarPickers:(NSInteger)selectnum {
    return calendarPicker[selectnum];
}
// 中央のカレンダーのポインタ取得
- (UICCalendarPicker *)getUICCalendarPickerCenter {
    return [self getUICCalendarPickers:CAL_NOW];
}

#pragma - ナビバーにボタン追加
// カレンダーを表示するナビゲーションバーに休日リスト取得ボタンを追加(右に追加される)
- (void)setNaviBarToHolidaysButton
{    
    if (!self.HolidayNSDatelist) {
        self.navigationItem.rightBarButtonItem = calendarPicker[CAL_NOW].getHolidayListBarButton;
        self.navigationItem.rightBarButtonItem.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    }
}
// 本日ボタン追加(左に追加される)
- (void)setNaviBarToNowDayButton
{
    self.navigationItem.leftBarButtonItem = calendarPicker[CAL_NOW].setNowDayBarButton;
    self.navigationItem.leftBarButtonItem.tintColor = self.navigationItem.leftBarButtonItem.tintColor;
}


#pragma - setter
- (void)setContentSize:(CGSize)contentSize
{
    _contentSize = contentSize;
    _scrollView.contentSize = _contentSize;
}
- (void)setBounds:(CGRect)bounds
{
    _bounds = bounds;
    _scrollView.bounds = _bounds;
}

- (void)setCaldelegate:(id)_id {
    [calendarPicker[CAL_NOW] setDelegate:_id];
}

#pragma mark - PagingCalViewControllerDelegate
// スクロールが停止した時
- (void)pagingCalViewDidEndDecelerating:(UIScrollView *)scrollView pageDiraction:(NSInteger)pageDirection
{
    if (pageDirection != 0) {
        // 月を変えてCalendarの日付を再セット
        NSDateComponents *dateComp = [[NSDateComponents alloc] init];
        // 1月前とする
        [dateComp setMonth:pageDirection];
        [self calendarMonthSet:[[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:cacheDate options:0]];
        // 表示位置をセンターに戻す
        [self.self scrollToCenterViewAnimated:NO];
        popTitle.text = calendarPicker[CAL_NOW].titleText; // ここはメソッドまとめて変更？
    }
}

// popupカレンダーの左右ボタン
- (void)popupCalendarMonthButton:(UIButton *)_button
{
    if (_button.tag > 0) {
        [self scrollToRightViewAnimated:YES];
    } else {
        [self scrollToLeftViewAnimated:YES];
    }
}

- (void)popupCalendarYearButton:(UIButton *)_button
{
    if (_button.tag > 0) {
        if (_scrollView.contentOffset.x - _currentViewPoint.x <= 0) {
            // 右へスクロール_bounds.size.width
            [_scrollView setContentOffset:CGPointMake(_bounds.size.width * 13, 0) animated:YES];
        }
    } else {
        if (_scrollView.contentOffset.x - _currentViewPoint.x >= 0) {
            // 左へスクロール
            [_scrollView setContentOffset:CGPointMake( - (_bounds.size.width * 11), 0) animated:YES];
        }
    }
}


// Calendarの日付セット
- (void)calendarMonthSet:(NSDate *)_date
{
    cacheDate = _date;
    // カレンダー作成
    calendarPicker[CAL_NOW].pageDate = _date;
    calendarPicker[CAL_NOW].holidaylist = self.HolidayNSDatelist;
    calendarPicker[CAL_NOW].closeButton.hidden = YES;
    [calendarPicker[CAL_NOW] setUpCalendarWithDate:calendarPicker[CAL_NOW].pageDate];
    CGRect tmpRect = calendarPicker[CAL_NOW].bounds;
    tmpRect.origin.x = calendarPicker[CAL_NOW].bounds.size.width;
    calendarPicker[CAL_NOW].frame = tmpRect;
    // Calendarあと２つ作る(先月、来月)delegateは不要
    // 日付のオフセットを生成
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    // 1月前とする
    [dateComp setMonth:-1];
    calendarPicker[CAL_OLD].pageDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:_date options:0];
    calendarPicker[CAL_OLD].holidaylist = self.HolidayNSDatelist;
    calendarPicker[CAL_OLD].closeButton.hidden = YES;
    [calendarPicker[CAL_OLD] setUpCalendarWithDate:calendarPicker[CAL_OLD].pageDate];
    calendarPicker[CAL_OLD].frame = calendarPicker[CAL_OLD].bounds;
    // 1月後とする
    [dateComp setMonth:1];
    calendarPicker[CAL_NEW].pageDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComp toDate:_date options:0];
    calendarPicker[CAL_NEW].holidaylist = self.HolidayNSDatelist;
    calendarPicker[CAL_NEW].closeButton.hidden = YES;
    [calendarPicker[CAL_NEW] setUpCalendarWithDate:calendarPicker[CAL_NEW].pageDate];
    tmpRect = calendarPicker[CAL_NEW].bounds;
    tmpRect.origin.x = calendarPicker[CAL_NEW].bounds.size.width * 2;
    calendarPicker[CAL_NEW].frame = tmpRect;
    
}

@end
