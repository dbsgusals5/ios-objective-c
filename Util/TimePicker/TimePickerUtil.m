//
//  TimePickerUtil.m
//  HousingPortal
//
//  Created by アルファー on 2019/02/04.
//  Copyright © 2019年 alpha. All rights reserved.
//

#import "TimePickerUtil.h"

@interface TimePickerUtil ()
@property (copy, nonatomic) TimePickerCompletion requestCompletion;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (nonatomic) NSString* selectedTimeStr;
@end

@implementation TimePickerUtil

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self changeTimePicker:_selectedTimeStr];
    
}

- (void) changeTimePicker : (NSString*) time {
    if([_selectedTimeStr isEqual:@""] || _selectedTimeStr == nil) {
        return;
    }
    
    NSArray *times = [time componentsSeparatedByString:@":"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate new]];
    comp.hour = [times[0] integerValue];
    comp.minute = [times[1] integerValue];
    
    NSDate *date = [calendar dateFromComponents:comp];
    [_timePicker setDate:date];
}

- (void) closePopup : (NSDate*) selectedDate {
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if(selectedDate != nil) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"ja_JP"]];
            NSDateComponents *comp = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:selectedDate];
            NSInteger hour = comp.hour;
            NSInteger minute = comp.minute - (comp.minute % [wself.timePicker minuteInterval]);
            NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld", hour, minute];
            wself.requestCompletion(timeStr);
        }
    }];
}

- (IBAction)selectBtnAction:(id)sender {
    NSDate *date = [self.timePicker date];
    [self closePopup : date];
}

- (IBAction)closeBtnAction:(id)sender {
    [self closePopup : nil];
}

+ (void)target:(UIViewController *)target soureView:(UIView *)view withDateTime:(NSString *)hhmm completion:(TimePickerCompletion)completion {
    
    TimePickerUtil *timePicker = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TimePicker"];
    timePicker.modalPresentationStyle = UIModalPresentationPopover;
    timePicker.requestCompletion = completion;
    timePicker.selectedTimeStr = hhmm;
    
    UIPopoverPresentationController *popover = timePicker.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popover.sourceView = view;
    popover.sourceRect = view.bounds;
    
    [target presentViewController:timePicker animated:YES completion:nil];
}

@end
