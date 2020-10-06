//
//  NegoUpdateViewController.m
//  iPadCourceYun
//
//  Created by alpha on 2019/09/19.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "NegoRegistViewController.h"
#import "CustomCalender.h"
#import "TimePicker/TimePickerUtil.h"
#import "NegoRegMeansViewController.h"
#import "NegoRegOtherViewController.h"
#import "CustomerInfoViewController.h"
#import <iCommonNetworkConnection/iCommonNetworkConnection.h>
#import "CusListConViewController.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "DropDownUtil.h"
@interface NegoRegistViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *CancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *RegistBtn;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *OtherRadioBtn;
@property (weak, nonatomic) IBOutlet UITextField *NegoTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *NextNegoDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *NegoMeansTextField;
@property (weak, nonatomic) IBOutlet UITextField *NegoOthersTextField;
@property (weak, nonatomic) IBOutlet UITextView *NegoContentTextView;
@property (weak, nonatomic) IBOutlet UITextField *NegoToolTextField;
@property (weak, nonatomic) IBOutlet UITextField *NegoCommentTextField;
@property (weak, nonatomic) IBOutlet UITextView *NegoSchTextView;
@property (copy, nonatomic) RenewData RenewData;
@property (weak, nonatomic) IBOutlet UITextField *NegoDateClear;
@property (weak, nonatomic) IBOutlet UITextField *NegoTimeClear;
@property (weak, nonatomic) IBOutlet UITextField *NextNegoDateClear;
@property (weak, nonatomic) IBOutlet UITextField *NegoMeansClear;
@property (nonatomic) NSString *NegoMeansName;
@property (nonatomic) NSString *NegoPartnerName;
@property (nonatomic) NSString *NegoPartnerNumber;
@property (weak, nonatomic) IBOutlet UITextField *NegoOthersClear;

@property (nonatomic) NSArray *negotiationMeansArray;
@property (nonatomic) NSArray *negoRegOthersArray;
@property (nonatomic) BOOL check;
@end

@implementation NegoRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.CancleBtn.layer.masksToBounds =YES;
    self.RegistBtn.layer.masksToBounds =YES;
    self.CancleBtn.layer.cornerRadius = 5;
    self.RegistBtn.layer.cornerRadius = 5;
    self.NegoDateTextField.delegate = self;
    self.NegoTimeTextField.delegate = self;
    self.NextNegoDateTextField.delegate = self;
    self.NegoMeansTextField.delegate = self;
    self.NegoOthersTextField.delegate = self;
    self.NegoSchTextView.delegate = self;
    self.NegoContentTextView.delegate = self;
    self.NegoToolTextField.delegate = self;
    self.NegoCommentTextField.delegate = self;
    self.NegoDateClear.delegate = self;
    self.NegoTimeClear.delegate = self;
    self.NegoMeansClear.delegate = self;
    self.NegoOthersClear.delegate = self;
    self.NextNegoDateClear.delegate = self;
    
    self.negotiationMeansArray = @[
    @{@"key":@"1", @"value":@"訪問"},
    @{@"key":@"2", @"value":@"電話"},
    @{@"key":@"3", @"value":@"文書"},
    @{@"key":@"4", @"value":@"来訪"}
    ];
    
    self.negoRegOthersArray = @[
        @{@"value":@"ご主人"},
        @{@"value":@"奥様"},
        @{@"value":@"父"},
        @{@"value":@"母"},
        @{@"value":@"子供"},
        @{@"value":@"その他"}
    ];
    
    if(self.insertedDic[@"branchCode"] != nil){
        [self setData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [DropDownUtil target:self withSoureView:self.NegoMeansClear withOptionList:_negotiationMeansArray withSelectedValue:self.insertedDic[@"negotiationMeans"]?:@"" completion:^(NSDictionary *selectedData) {
        self.NegoMeansName = [selectedData objectForKey:@"value"];
    }];
    
    [DropDownUtil target:self withSoureView:self.NegoOthersClear withOptionList:self.negoRegOthersArray withSelectedValue:self.insertedDic[@"negotiationPartner"]?:@"" completion:^(NSDictionary *selectedData) {
      //self.NegoPartnerName = [selectedData objectForKey:@"value"];
    }];
}

-(void)setData{
    self.NegoDateClear.text = self.insertedDic[@"negotiationDate"];
    self.NegoTimeClear.text = self.insertedDic[@"negotiationTime"];
    self.NextNegoDateClear.text = self.insertedDic[@"nextNegotiationDate"];
    //self.NegoMeansClear.text = self.insertedDic[@"negotiationMeans"];
    self.NegoMeansName = self.insertedDic[@"negotiationMeans"];
    //self.NegoPartnerName = self.insertedDic[@"negotiationPartner"];
    self.NegoContentTextView.text = self.insertedDic[@"negotiationContent"];
    self.NegoToolTextField.text = self.insertedDic[@"catalogContents"];
    self.NegoCommentTextField.text = self.insertedDic[@"otherConsiderations"];
    self.NegoSchTextView.text = self.insertedDic[@"nextActionPlan"];
    
    if([self.insertedDic[@"negotiationPartner"] isEqualToString:@"ご主人"]){
        self.NegoPartnerNumber = @"1";
    }else if([self.insertedDic[@"negotiationPartner"] isEqualToString:@"奥様"]){
        self.NegoPartnerNumber = @"2";
    }else if([self.insertedDic[@"negotiationPartner"] isEqualToString:@"父"]){
        self.NegoPartnerNumber = @"3";
    }else if([self.insertedDic[@"negotiationPartner"] isEqualToString:@"母"]){
        self.NegoPartnerNumber = @"4";
    }else if([self.insertedDic[@"negotiationPartner"] isEqualToString:@"子供"]){
        self.NegoPartnerNumber = @"5";
    }else if([self.insertedDic[@"negotiationPartner"] isEqualToString:@"その他"]){
        self.NegoPartnerNumber = @"9";
    }else {
        self.NegoPartnerNumber = @"";
    }
    [self SetPartnerBtnImage:[self.NegoPartnerNumber intValue] check:YES];
}

- (void)RegistReq:(NSString *)cusNum {
    self.CusNum = cusNum;
}

- (IBAction)CloseBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField == self.NegoDateTextField){
        [CustomCalender createCalendarWithTargetTextField:self.NegoDateClear format:@"yyyy/MM/dd"
                                             initDate:[CustomCalender createNSDateFromString:self.NegoDateClear.text format:@"yyyy/MM/dd"]
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                           completion:^(CustomCalender *calender, NSDate *selectDay) {
                                               self.NegoDateClear.text = [CustomCalender createDateStringFromNSDate:selectDay format:@"yyyy/MM/dd"];
                                           }];
        
        return NO;
    }else if(textField == self.NegoDateClear || textField == self.NegoTimeClear || textField == self.NextNegoDateClear ||
             textField == self.NegoOthersClear){
        return NO;
    }else if(textField == self.NegoTimeTextField){
        
        [TimePickerUtil target:self soureView:self.NegoTimeClear withDateTime:self.NegoTimeClear.text completion:^(NSString *timeStr) {
            self.NegoTimeClear.text = timeStr;
        }];
        return NO;
    }else if(textField == self.NextNegoDateTextField){
        [CustomCalender createCalendarWithTargetTextField:self.NextNegoDateClear format:@"yyyy/MM/dd"
                                                 initDate:[CustomCalender createNSDateFromString:self.NextNegoDateClear.text format:@"yyyy/MM/dd"]
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                               completion:^(CustomCalender *calender, NSDate *selectDay) {
                                                   self.NextNegoDateClear.text = [CustomCalender createDateStringFromNSDate:selectDay format:@"yyyy/MM/dd"];
                                               }];
        return NO;
    }
//    else if(textField == self.NegoMeansTextField){
//        [[NegoRegMeansViewController target:self soureView:self.NegoMeansClear completion:^(NSString *MeansStr) {
//            self.NegoMeansClear.text = MeansStr;
//        }];
//     else if(textField == self.NegoMeansClear){
//         [DropDownUtil target:self withSoureView:self.NegoMeansClear withOptionList:_negotiationMeansArray withSelectedValue:self.insertedDic[@"negotiationMeans"]?:@"" completion:^(NSDictionary *selectedData) {
//             self.NegoMeansClear.text = [selectedData objectForKey:@"key"];
//         }];
//        return NO;
    else if(textField == self.NegoOthersTextField){
        [NegoRegOtherViewController target:self soureView:self.NegoOthersClear completion:^(NSString *OtherStr) {
            self.NegoOthersClear.text = OtherStr;
        }];
        return NO;
    }
    return YES;
}
- (void)SetPartnerBtnImage:(int)selectedBtn check:(BOOL)check{
    
    for(UIButton *btn in self.OtherRadioBtn){
        if(selectedBtn == [btn tag]){
            if(check){
                [btn setImage:[UIImage imageNamed:@"check_on"]
                    forState:UIControlStateNormal];
                self.NegoPartnerNumber = [NSString stringWithFormat:@"%d",(int)[btn tag]];
                [btn setSelected:YES];
            }else{
                [btn setImage:[UIImage imageNamed:@"check_off"]
                    forState:UIControlStateNormal];
                self.NegoPartnerNumber = @"";
                [btn setSelected:NO];
            }
        }
    }
    
}
- (IBAction)OthersBtnClick:(UIButton *)sender {
    int tag = (int)[sender tag];
    
    for(UIButton *btn in self.OtherRadioBtn){
           if([btn tag] != [sender tag]){
                [btn setImage:[UIImage imageNamed:@"check_off"]
                       forState:UIControlStateNormal];
           }
    }
    
    switch (tag) {
        case 1:
            [self SetPartnerBtnImage:tag check:![sender isSelected]];
            break;
        case 2:
            [self SetPartnerBtnImage:tag check:![sender isSelected]];
            break;
        case 3:
            [self SetPartnerBtnImage:tag check:![sender isSelected]];
            break;
        case 4:
            [self SetPartnerBtnImage:tag check:![sender isSelected]];
            break;
        case 5:
            [self SetPartnerBtnImage:tag check:![sender isSelected]];
            break;
        case 9:
            [self SetPartnerBtnImage:tag check:![sender isSelected]];
            break;
        default:
            break;
    }
    
    
}

- (IBAction)RegistBtnClick:(id)sender {
    NSString *means;
    NSString *others;

//    if([self.NegoMeansClear.text isEqualToString:@"訪問"]){
//        means = @"1";
//    }else if([self.NegoMeansClear.text isEqualToString:@"電話"]){
//        means = @"2";
//    }else if([self.NegoMeansClear.text isEqualToString:@"文書"]){
//        means = @"3";
//    }else if([self.NegoMeansClear.text isEqualToString:@"来訪"]){
//        means = @"4";
//    }else{
//        means = @"";
//    }
    
    if([self.NegoMeansName isEqualToString:@"訪問"]){
        means = @"1";
    }else if([self.NegoMeansName isEqualToString:@"電話"]){
        means = @"2";
    }else if([self.NegoMeansName isEqualToString:@"文書"]){
        means = @"3";
    }else if([self.NegoMeansName isEqualToString:@"来訪"]){
        means = @"4";
    }else{
        means = @"";
    }
    
//    if([self.NegoPartnerName isEqualToString:@"ご主人"]){
//        others = @"1";
//    }else if([self.NegoPartnerName isEqualToString:@"奥様"]){
//        others = @"2";
//    }else if([self.NegoPartnerName isEqualToString:@"父"]){
//        others = @"3";
//    }else if([self.NegoPartnerName isEqualToString:@"母"]){
//        others = @"4";
//    }else if([self.NegoPartnerName isEqualToString:@"子供"]){
//         others = @"5";
//    }else if([self.NegoPartnerName isEqualToString:@"その他"]){
//        others = @"9";
//    }else{
//        others = @"";
//    }
    
    
    NSString *historyCheck;
    if(self.insertedDic[@"historySeq"] != nil){
        historyCheck = self.insertedDic[@"historySeq"];
    }else{
        historyCheck = @"";
    }
    
    if(self.NegoDateClear.text.length == 0){
        [self showErrorAlertWithTitle:@"エラー" message:@"折衝日は必須項目です。" actionFunc:nil];
    }else if(self.NegoContentTextView.text.length == 0){
        [self showErrorAlertWithTitle:@"エラー" message:@"折衝内容は必須項目です。" actionFunc:nil];
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSDictionary *dictionary = @{
                                        @"branchCode":appDelegate.branchCode,
        
                                        @"verificationFlag":@"",
        
                                        @"historySeq":historyCheck,
        
                                        @"staffCode":appDelegate.staffCode,
        
                                        @"customerNumber":self.CusNum,
        
                                        @"negotiationDate":self.NegoDateClear.text,
        
                                        @"negotiationTime":self.NegoTimeClear.text,
        
                                        @"negotiationMeans":means,
        
                                        @"negotiationPartner":self.NegoPartnerNumber,
        
                                        @"negotiationContent":self.NegoContentTextView.text,
        
                                        @"catalogContents":self.NegoToolTextField.text,
        
                                        @"otherConsiderations":self.NegoCommentTextField.text,
        
                                        @"nextActionPlan":self.NegoSchTextView.text,
        
                                        @"nextNegotiationDate":self.NextNegoDateClear.text
                                        };
        [DataController dbConn:appDelegate.authId dic:dictionary initMode:27 complete:^(NSDictionary * result) {
            self.RenewData();
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

-(void) RenewData : (RenewData) block{
    self.RenewData = block;
}

- (void)showErrorAlertWithTitle:(NSString *)titleText message:(NSString *)messageText actionFunc:(void (^)(UIAlertAction *))actionFunc{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:titleText message:messageText preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:cancleAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSMutableString *str = [textView.text mutableCopy];
    [str replaceCharactersInRange:range withString:text];
    NSUInteger byte = [str lengthOfBytesUsingEncoding:NSShiftJISStringEncoding];
    // 折衝内容
    if([textView isEqual: self.NegoContentTextView]) {
        int maxByte = 400;
        if(byte > maxByte || str.length > 200) {
            return NO;
        }
    }else if([textView isEqual:self.NegoSchTextView]){
        int maxByte = 60;
        if(byte > maxByte || str.length > 30) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *str = [textField.text mutableCopy];
    [str replaceCharactersInRange:range withString:string];
    NSUInteger byte = [str lengthOfBytesUsingEncoding:NSShiftJISStringEncoding];
    if([textField isEqual: self.NegoToolTextField]) {
        int maxByte = 40;
        if(byte > maxByte || str.length > 20) {
            return NO;
        }
    }else if([textField isEqual:self.NegoCommentTextField]){
        int maxByte = 40;
        if(byte > maxByte || str.length > 20) {
            return NO;
        }
    }
    return YES;
}

@end
