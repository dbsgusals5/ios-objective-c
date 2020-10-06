//
//  CusListConViewController.m
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/06.
//  Copyright © 2019 alpha. All rights reserved.
//
#import "NegoRegistViewController.h"
#import "CustomerViewController.h"
#import "CusListConViewController.h"
#import "CusInfoConViewController.h"
#import "CusListConTableViewCell.h"
#import <iCommonNetworkConnection/iCommonNetworkConnection.h>
#import "AppDelegate.h"
#import "DataController.h"
@interface CusListConViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *DelBtn;
@property (weak, nonatomic) IBOutlet UIButton *UpdateBtn;
@property (weak, nonatomic) IBOutlet UIButton *NewBtn;
@property (weak, nonatomic) IBOutlet UITableView *CusListConTableView;
@property (weak, nonatomic) IBOutlet UILabel *Consider;
@property (weak, nonatomic) IBOutlet UILabel *NextPlan;
@property (weak, nonatomic) IBOutlet UILabel *SelectedInfo;
@end

@implementation CusListConViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.DelBtn.layer.masksToBounds = YES;
    self.UpdateBtn.layer.masksToBounds = YES;
    self.NewBtn.layer.masksToBounds = YES;
    self.DelBtn.layer.cornerRadius = 5;
    self.UpdateBtn.layer.cornerRadius = 5;
    self.NewBtn.layer.cornerRadius = 5;
    self.CusListConTableView.delegate = self;
    self.CusListConTableView.dataSource = self;
}

-(void)ListClear{
    self.Consider.text = @"";
    self.NextPlan.text = @"";
    self.SelectedInfo.text = @"";
    self.array = [[NSArray alloc]init];
    [self.CusListConTableView reloadData];
}

- (void)conNego:(NSDictionary *)dic{
    self.CusNegoDic = dic[@"negotiationNextScheduled"];
    self.array = dic[@"negotiationContentList"];
    

    self.Consider.text = self.CusNegoDic[@"otherConsiderations"];
    self.NextPlan.text =self.CusNegoDic [@"nextActionPlan"];
    
    self.DelBtn.hidden = YES;
    self.UpdateBtn.hidden = YES;
    [self.CusListConTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.array count];
}

- (CusListConTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CusListConTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CusListConCell" forIndexPath:indexPath];
    
    cell.NegoDate.text = self.array[indexPath.row][@"negotiationDateAndTime"];
    cell.SalesName.text = self.array[indexPath.row][@"salesRepresentativeName"];
    cell.NegoMeans.text = self.array[indexPath.row][@"negotiationMeans"];
    cell.NegoPartner.text = self.array[indexPath.row][@"negotiationPartner"];
    cell.NextNegoDate.text = self.array[indexPath.row][@"nextNegotiationDate"];
    cell.NegoContent.text = self.array[indexPath.row][@"negotiationContent"];
    cell.NegoPlan.text = self.array[indexPath.row][@"nextActionPlan"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.DelBtn.hidden = NO;
    self.UpdateBtn.hidden = NO;
    self.CheckedIndex = indexPath;
}

- (void)PromisingInformation:(NSDictionary *)promisingDic{
    self.PromisingDic = promisingDic[@"customerInformation"];
    
    self.SelectedInfo.text = [NSString stringWithFormat:@"%@ %@ (%@) %@",self.PromisingDic[@"customerNumber"],self.PromisingDic[@"name"],self.PromisingDic[@"nameKana"],@"様"];
}

- (IBAction)DelBtn:(id)sender{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self showErrorAlertWithTitle:@"確認" message:@"削除します。よろしいですか?" actionFunc:^(UIAlertAction *delCheck) {
        NSIndexPath *indexPath = self.CheckedIndex;
        NSDictionary *dictionary = @{
                                    @"branchCode":self.array[indexPath.row][@"branchCode"],
                                     
                                    @"verificationFlag":@"1",
                                     
                                    @"staffCode":appDelegate.staffCode,
                                     
                                    @"customerNumber":self.array[indexPath.row][@"customerNumber"],
                                     
                                    @"historySeq":self.array[indexPath.row][@"historySeq"]
                                     
                                    };
        [DataController dbConn:appDelegate.authId dic:dictionary initMode:28 complete:^(NSDictionary * _Nonnull result) {
            NSDictionary *dictionary = @{
                                         @"branchCode":appDelegate.branchCode,
                                          
                                         @"customerNumber":self.PromisingDic[@"customerNumber"]
                                          
                                       //@"dbSchemaName":self.LoginDic[@"authorization"][@"dbSchemaName"]
                                        };
            [DataController dbConn:appDelegate.authId dic:dictionary initMode:9 complete:^(NSDictionary * _Nonnull result) {
                [self conNego:result];
            }];
        }];
    }];
}

- (IBAction)NewNegoBtn:(id)sender {
    NegoRegistViewController *newModal = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewNego"];
    newModal.CusNum = self.PromisingDic[@"customerNumber"];
    //newModal.LoginDic = self.LoginDic;
    newModal.modalPresentationStyle = UIModalPresentationFormSheet;
    newModal.preferredContentSize = CGSizeMake(500.0f, 480.0f);
    [newModal RenewData:^{
        //[self RenewData];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *dictionary = @{
                                     @"branchCode":appDelegate.branchCode,
                                     
                                     @"customerNumber":self.PromisingDic[@"customerNumber"]
                                     
                                     //@"dbSchemaName":self.LoginDic[@"authorization"][@"dbSchemaName"]
                                     };
        [DataController dbConn:appDelegate.authId dic:dictionary initMode:9 complete:^(NSDictionary * _Nonnull result) {
            [self conNego:result];
        }];
        
    }];
    [self presentViewController:newModal animated:YES completion:nil];
}

- (IBAction)UpdateBtn:(id)sender {
    NSIndexPath *indexPath = self.CheckedIndex;
    NegoRegistViewController *newModal = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewNego"];
    newModal.modalPresentationStyle = UIModalPresentationFormSheet;
    newModal.preferredContentSize = CGSizeMake(500.0f, 480.0f);
    newModal.CusNum = self.PromisingDic[@"customerNumber"];
    //newModal.LoginDic = self.LoginDic;
    newModal.insertedDic = self.array[indexPath.row];
    [newModal RenewData:^{
        //[self RenewData];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *dictionary = @{
                                     @"branchCode":appDelegate.branchCode,
                                     
                                     @"customerNumber":self.PromisingDic[@"customerNumber"]
                                     
                                     //@"dbSchemaName":self.LoginDic[@"authorization"][@"dbSchemaName"]
                                     };
        [DataController dbConn:appDelegate.authId dic:dictionary initMode:9 complete:^(NSDictionary * _Nonnull result) {
            [self conNego:result];
        }];
    }];
    [self presentViewController:newModal animated:YES completion:nil];
}

- (void)showErrorAlertWithTitle:(NSString *)titleText message:(NSString *)messageText actionFunc:(void (^)(UIAlertAction *))actionFunc{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:titleText message:messageText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionFunc(action);
    }];
    [errorAlert addAction:okAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleCancel handler:nil];
    [errorAlert addAction:cancleAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
