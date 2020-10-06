//
//  CusInfoConViewController.m
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/06.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "CusInfoConViewController.h"
#import "CusInfoConTableViewCell.h"
#import <iCommonNetworkConnection/iCommonNetworkConnection.h>
#import "CustomerInfoViewController.h"
#import "MapViewController.h"
#import "MFMailViewController/OriginalMailViewController.h"
#import "CusListConViewController.h"
@interface CusInfoConViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *CusUpdateBtn;
@property (weak, nonatomic) IBOutlet UIButton *MapBtn;
@property (weak, nonatomic) IBOutlet UIButton *MailBtn;
@property (weak, nonatomic) IBOutlet UIButton *DelBtn;
@property (weak, nonatomic) IBOutlet UIButton *NewBtn;
@property (weak, nonatomic) IBOutlet UIButton *UpdateBtn;
@property (weak, nonatomic) IBOutlet UILabel *NameKanji;
@property (weak, nonatomic) IBOutlet UILabel *QnaCode;
@property (weak, nonatomic) IBOutlet UILabel *SalesName;
@property (weak, nonatomic) IBOutlet UILabel *Addr;
@property (weak, nonatomic) IBOutlet UILabel *TEL1;
@property (weak, nonatomic) IBOutlet UILabel *TEL2;
@property (weak, nonatomic) IBOutlet UILabel *Email;
@property (weak, nonatomic) IBOutlet UILabel *WorkName;
@property (weak, nonatomic) IBOutlet UILabel *TEL;
@property (weak, nonatomic) IBOutlet UILabel *SetName;
@property (weak, nonatomic) IBOutlet UILabel *BuildName;
@property (weak, nonatomic) IBOutlet UILabel *Fax;
@property (weak, nonatomic) IBOutlet UILabel *Birth;
@property (weak, nonatomic) IBOutlet UITableView *CusInfoConTableView;
@property (weak, nonatomic) IBOutlet UIButton *RankBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectedInfo;

@end

@implementation CusInfoConViewController
@synthesize CusInfoDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.DelBtn.layer.masksToBounds = YES;
    self.UpdateBtn.layer.masksToBounds = YES;
    self.NewBtn.layer.masksToBounds = YES;
    self.CusUpdateBtn.layer.masksToBounds = YES;
    self.MapBtn.layer.masksToBounds = YES;
    self.MailBtn.layer.masksToBounds = YES;
    self.DelBtn.layer.cornerRadius = 5;
    self.UpdateBtn.layer.cornerRadius = 5;
    self.NewBtn.layer.cornerRadius = 5;
    self.CusUpdateBtn.layer.cornerRadius = 5;
    self.MapBtn.layer.cornerRadius = 5;
    self.MailBtn.layer.cornerRadius = 5;
     self.CusInfoConTableView.delegate= self;
    self.CusInfoConTableView.dataSource= self;
}

-(void)InfoClear{
    self.NameKana.text = @"";
    self.NameKanji.text = @"";
    self.Birth.text = @"";
    self.QnaCode.text = @"";
    self.SalesName.text = @"";
    self.SetName.text = @"";
    self.BuildName.text = @"";
    self.Addr.text = @"";
    self.TEL1.text = @"";
    self.TEL2.text = @"";
    self.Fax.text = @"";
    self.Email.text = @"";
    self.WorkName.text = @"";
    self.TEL.text = @"";
    self.selectedInfo.text = @"";
    self.MapBtn.hidden = YES;
    self.MailBtn.hidden = YES;
    self.RankBtn.hidden = YES;
    self.array = [[NSArray alloc]init];
    [self.CusInfoConTableView reloadData];
    
}

- (void)test:(NSDictionary *)dic CustomerNumber:(NSString *)customerNumber {
    self.RankBtn.hidden = NO;
    self.CusInfoDic = dic[@"customerInformation"];
    self.array = dic[@"introducerInformation"];
    self.NameKana.text = self.CusInfoDic[@"nameKana"];
    self.NameKanji.text = self.CusInfoDic[@"name"];
    self.Birth.text = self.CusInfoDic[@"birthday"];
    self.QnaCode.text = self.CusInfoDic[@"inquiriesCode"];
    self.SalesName.text = self.CusInfoDic[@"salesStaff"];
    self.SetName.text = self.CusInfoDic[@"designersStaff"];
    self.BuildName.text = self.CusInfoDic[@"architecturalCharge"];
    self.Addr.text = self.CusInfoDic[@"streetAddress"];
    self.TEL1.text = self.CusInfoDic[@"ph1Number"];
    self.TEL2.text = self.CusInfoDic[@"ph2Number"];
    self.Fax.text = self.CusInfoDic[@"faxNumber"];
    self.Email.text = self.CusInfoDic[@"mailAddress"];
    self.WorkName.text = self.CusInfoDic[@"placeOfEmployment"];
    self.TEL.text = self.CusInfoDic[@"workPh1Number"];
    self.selectedInfo.text = [NSString stringWithFormat:@"%@ %@ (%@) %@",customerNumber,self.NameKanji.text,self.NameKana.text,@"様"];
    
    self.MapBtn.hidden = YES;
    
    if(self.Addr.text.length > 0){
        self.MapBtn.hidden = NO;
    }

    if(self.Email.text.length == 0){
        self.MailBtn.hidden = YES;
    }else{
        self.MailBtn.hidden = NO;
    }
    
    NSString *rank = self.CusInfoDic[@"rank"];
    self.RankBtn.userInteractionEnabled = NO;
    if([rank isEqualToString:@"A"]){
        UIImage *rankBtnImage = [UIImage imageNamed:@"filter_a_on@2x.png"];
        [self.RankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    }else if([rank isEqualToString:@"B"]){
        UIImage *rankBtnImage = [UIImage imageNamed:@"filter_b_on@2x.png"];
        [self.RankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    }else if([rank isEqualToString:@"C"]){
        UIImage *rankBtnImage = [UIImage imageNamed:@"filter_c_on@2x.png"];
        [self.RankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    }else if([rank isEqualToString:@"D"]){
        UIImage *rankBtnImage = [UIImage imageNamed:@"filter_d_on@2x.png"];
        [self.RankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    }else if([rank isEqualToString:@"Z"]){
        UIImage *rankBtnImage = [UIImage imageNamed:@"filter_z_on@2x.png"];
        [self.RankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    }else if([rank isEqualToString:@"Y"]){
        UIImage *rankBtnImage = [UIImage imageNamed:@"filter_y_on@2x.png"];
        [self.RankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    }else if([rank isEqualToString:@"E"]){
        UIImage *rankBtnImage = [UIImage imageNamed:@"filter_e_on@2x.png"];
        [self.RankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    }
    
    [self.CusInfoConTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.array count];
}

- (CusInfoConTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CusInfoConTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CusInfoConCell" forIndexPath:indexPath];
    cell.IntroDate.text = self.array[indexPath.row][@"introductionDate"];
    cell.IntroName.text = self.array[indexPath.row][@"introductionName"];
    cell.IntroNameKana.text = self.array[indexPath.row][@"introductionNameKana"];
    cell.UserAddr.text = self.array[indexPath.row][@"streetAddress"];
    cell.UserTel.text = self.array[indexPath.row][@"ph1Number"];
    cell.WorkName.text = self.array[indexPath.row][@"officeName"];
    cell.UserRel.text = self.array[indexPath.row][@"introducerRelationship"];
    cell.Comment.text =  self.array[indexPath.row][@"considerations"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (IBAction)MapBtnDown:(id)sender {
    MapViewController *map = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"map"];
    map.CusAddr = self.Addr.text;
    map.CusName = self.NameKana.text;
    [self.navigationController pushViewController:map animated:YES];
}

- (IBAction)MailBtn:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [MFMailComposeViewController new];
        mailCont.mailComposeDelegate = self;
        NSArray *mailArr = @[self.CusInfoDic[@"mailAddress"]];
        [mailCont setToRecipients:mailArr];
        [self presentViewController:mailCont animated:YES completion:^{
            NSLog(@"%@",@"complate");
        }];
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",@"comple2");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


