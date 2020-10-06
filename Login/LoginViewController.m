//
//  LoginViewController.m
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/03.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomerInfoViewController.h"
#import <iCommonNetworkConnection/iCommonNetworkConnection.h>
#import "AppDelegate.h"
#import "DataController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic) BOOL dbConnCheck;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.LoginBtn.layer.masksToBounds = YES;
    self.LoginBtn.layer.cornerRadius = 5;
    
    self.UserIdText.delegate = self;
    self.UserPwText.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.LoginBtn.enabled = YES;
    self.UserPwText.text = @"";
}

- (IBAction)LoginBtn:(id)sender {
    self.UserIdText.text = @"";
    self.UserPwText.text = @"";
    NSString *userId = self.UserIdText.text;
    NSString *userPw = self.UserPwText.text;
    
    if([userId isEqualToString:@""] && [userPw isEqualToString:@""]){
        [self showErrorAlertWithTitle:@"ログインエラー" message:@"ユーザー名、パスコードが入力されていません。" actionFunc:nil];
        self.LoginBtn.enabled = YES;
        return;
        
    }else if(userId.length == 0 && userPw.length >0){
        [self showErrorAlertWithTitle:@"ログインエラー" message:@"ユーザー名が入力されていません。" actionFunc:nil];
        self.LoginBtn.enabled = YES;
        return;
        
    }else if(userId.length > 0 && userPw.length == 0 ){
        [self showErrorAlertWithTitle:@"ログインエラー" message:@"パスコードが入力されていません。" actionFunc:nil];
        self.LoginBtn.enabled = YES;
        return;
    }
    
  self.LoginBtn.enabled = NO;
    
  NSDictionary *dictionary = @{
                                @"passCode":userPw
                              };
    int init = 1;
    
    [DataController dbConn:userId dic:dictionary initMode:init complete:^(NSDictionary *result){
        NSLog(@"DB SUCSUC");
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSMutableDictionary *mdic = result[@"authorization"];
        NSString *s = mdic[@"privateAuthId"];
        
        appDelegate.authId = result[@"authorization"][@"privateAuthId"]; 
        appDelegate.branchCode = result[@"authorization"][@"branchCode"];
        appDelegate.staffCode = result[@"authorization"][@"staffCode"];
        appDelegate.name = result[@"authorization"][@"name"];
        
        if([result[@"authorization"][@"branchCode"] isEqualToString:@""]){
            [self showErrorAlertWithTitle:@"ログインエラー" message:@"ユーザー名、パスコードが一致しません。" actionFunc:nil];
            return;
          }
        NSDictionary *dictionary = @{
                                        @"branchCode":appDelegate.branchCode,
                                        @"staffCode":appDelegate.staffCode
                                    };
        [DataController dbConn:appDelegate.authId dic:dictionary initMode:2 complete:^(NSDictionary *result){
            CustomerInfoViewController *customer = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Customer"];
            customer.CusDic = result;
            customer.array = result[@"promisingInformation"];
            [self.navigationController pushViewController:customer animated:YES];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showErrorAlertWithTitle:(NSString *)titleText message:(NSString *)messageText actionFunc:(void (^)(UIAlertAction *))actionFunc{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:titleText message:messageText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:cancleAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL) textFieldShouldBeginEditing : (UITextField *) textField {
    return YES;
}

@end
