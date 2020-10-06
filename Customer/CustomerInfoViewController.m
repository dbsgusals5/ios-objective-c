//
//  CustomerInfoViewController.m
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/05.FA
//  Copyright © 2019 alpha. All rights reserved.
//

#import "CustomerInfoViewController.h"
#import "NameSortTableViewCell.h"
#import "CusInfoTableViewCell.h"
#import "LoginViewController.h"
#import <iCommonNetworkConnection/iCommonNetworkConnection.h>
#import "CusInfoConViewController.h"
#import "CusListConViewController.h"
#import "NegoRegistViewController.h"
#import "AppDelegate.h"
#import "DataController.h"
@interface CustomerInfoViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *LogOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *AllCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *AllRelBtn;
@property (weak, nonatomic) IBOutlet UITableView *CusInfoListTableView;
@property (weak, nonatomic) IBOutlet UITableView *NameSortTableView;
@property (weak, nonatomic) IBOutlet UIButton *ContractBtn;
@property (weak, nonatomic) IBOutlet UIButton *NegoBtn;
@property (weak, nonatomic) IBOutlet UILabel *ContractLabel;
@property (weak, nonatomic) IBOutlet UILabel *NegoLabel;
@property (weak, nonatomic) IBOutlet UIButton *ArankBtn;
@property (weak, nonatomic) IBOutlet UIButton *BrankBtn;
@property (weak, nonatomic) IBOutlet UIButton *CrankBtn;
@property (weak, nonatomic) IBOutlet UIButton *DrankBtn;
@property (weak, nonatomic) IBOutlet UIButton *ErankBtn;
@property (weak, nonatomic) IBOutlet UIButton *YrankBtn;
@property (weak, nonatomic) IBOutlet UIButton *ZrankBtn;
@property (weak, nonatomic) IBOutlet UIButton *ContractImg;
@property (weak, nonatomic) IBOutlet UIButton *NegoImg;
@property (nonatomic) NSArray *filterResultArr;
@property (nonatomic) NSArray *nameFilterArr;
@property (nonatomic) NSArray *resultArr;
@property (nonatomic) NSArray *filterA;
@property (nonatomic) NSArray *filterB;
@property (nonatomic) NSArray *filterC;
@property (nonatomic) NSArray *filterD;
@property (nonatomic) NSArray *filterE;
@property (nonatomic) NSArray *filterY;
@property (nonatomic) NSArray *filterZ;
@property (nonatomic) BOOL Atoggle;
@property (nonatomic) BOOL Btoggle;
@property (nonatomic) BOOL Ctoggle;
@property (nonatomic) BOOL Dtoggle;
@property (nonatomic) BOOL Etoggle;
@property (nonatomic) BOOL Ytoggle;
@property (nonatomic) BOOL Ztoggle;
@property (nonatomic) NSMutableArray *mutable;
@property (weak, nonatomic) NSString *CusNum;

@end

@implementation CustomerInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.LogOutBtn.layer.masksToBounds = YES;
    self.AllCheckBtn.layer.masksToBounds = YES;
    self.AllRelBtn.layer.masksToBounds = YES;
    self.LogOutBtn.layer.cornerRadius = 5;
    self.AllCheckBtn.layer.cornerRadius = 5;
    self.AllRelBtn.layer.cornerRadius = 5;
    self.CusInfoListTableView.delegate = self;
    self.CusInfoListTableView.dataSource = self;
    self.NameSortTableView.delegate = self;
    self.NameSortTableView.dataSource = self;
    self.NegoImg.userInteractionEnabled = NO;
    self.ContractImg.userInteractionEnabled = NO;
    
    [self filterCheck];
    
    self.arrayCp = self.array;
    self.Atoggle = true;
    self.Btoggle = true;
    self.Ctoggle = true;
    self.Dtoggle = true;
    self.Etoggle = true;
    self.Ytoggle = true;
    self.Ztoggle = true;
    
    self.resultArr = self.arrayCp;
    
    self.NameArray = @[
                      @{@"value":@"全"},
                      @{@"value":@"あ"},
                      @{@"value":@"か"},
                      @{@"value":@"さ"},
                      @{@"value":@"た"},
                      @{@"value":@"な"},
                      @{@"value":@"は"},
                      @{@"value":@"ま"},
                      @{@"value":@"や"},
                      @{@"value":@"ら"},
                      @{@"value":@"わ"},
                      @{@"value":@"他"}
                      ];
  
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
   
    [self.NameSortTableView selectRowAtIndexPath:indexPath
                                           animated:YES
                                     scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.NameSortTableView didSelectRowAtIndexPath:indexPath];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.CusInfoListTableView selectRowAtIndexPath:indexPath
                                           animated:YES
                                     scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.CusInfoListTableView didSelectRowAtIndexPath:indexPath];
}

-(void)firstCheck{
    NSIndexPath *indexPath2;
    if(self.resultArr.firstObject){
        for (NSDictionary *dic in self.resultArr) {
            if([self.CusNum isEqualToString:dic[@"customerNumber"]]){
                NSInteger i = [self.resultArr indexOfObject:dic];
                indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }else{
                indexPath2 = [NSIndexPath indexPathForRow:0 inSection:0];
            }
        }
    }
    [self tableView:self.CusInfoListTableView didSelectRowAtIndexPath:indexPath2];
    [self.CusInfoListTableView selectRowAtIndexPath:indexPath2
                                           animated:YES
                                     scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _CusInfoListTableView){
        return [self.resultArr count];
    }else if(tableView == _NameSortTableView){
        return [self.NameArray count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == _CusInfoListTableView){
        CusInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cusInfoListCell" forIndexPath:indexPath];
        
         cell.CusName.text = self.resultArr[indexPath.row][@"name"];
         cell.CusNumber.text = self.resultArr[indexPath.row][@"customerNumber"];
         cell.CusAddr.text = self.resultArr[indexPath.row][@"contactAddress"];
         cell.LastJoin.text = self.resultArr[indexPath.row][@"lastVisit"];
         cell.NextJoin.text = self.resultArr[indexPath.row][@"nextVisit"];
         NSString *rank = self.resultArr[indexPath.row][@"rank"];
    
        UIImage *rankImage = [[UIImage alloc] init];
    
        if([rank isEqualToString:@"A"]){
            rankImage = [UIImage imageNamed:@"filter_a_on@2x.png"];
            cell.RankImage.image = rankImage;
        }else if([rank isEqualToString:@"B"]){
            rankImage = [UIImage imageNamed:@"filter_b_on@2x.png"];
            cell.RankImage.image = rankImage;
        }else if([rank isEqualToString:@"C"]){
            rankImage = [UIImage imageNamed:@"filter_c_on@2x.png"];
            cell.RankImage.image = rankImage;
        }else if([rank isEqualToString:@"D"]){
            rankImage = [UIImage imageNamed:@"filter_d_on@2x.png"];
            cell.RankImage.image = rankImage;
        }else if([rank isEqualToString:@"Z"]){
            rankImage = [UIImage imageNamed:@"filter_z_on@2x.png"];
            cell.RankImage.image = rankImage;
        }else if([rank isEqualToString:@"Y"]){
            rankImage = [UIImage imageNamed:@"filter_y_on@2x.png"];
            cell.RankImage.image = rankImage;
        }else if([rank isEqualToString:@"E"]){
            rankImage = [UIImage imageNamed:@"filter_e_on@2x.png"];
            cell.RankImage.image = rankImage;
        }
        
        NSDate *today = [[NSDate alloc] init];
        NSDate *todayAdd14 = [today dateByAddingTimeInterval:+14*24*60*60];
        NSDate *todayAdd1 = [today dateByAddingTimeInterval:+1*24*60*60];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yy/MM/dd";
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSString *strTodayAdd1 = [dateFormatter stringFromDate:todayAdd1];
        NSString *strTodayAdd14 = [dateFormatter stringFromDate:todayAdd14];
        NSDate *dateTodayAdd1 = [dateFormatter dateFromString:strTodayAdd1];
        NSDate *dateTodayAdd14 =[dateFormatter dateFromString:strTodayAdd14];
        
        NSDate *dateCell =[dateFormatter dateFromString:cell.NextJoin.text];
        
        NSDate *today2 = [[NSDate alloc] init];
        NSDate *todaySub14 = [today dateByAddingTimeInterval:-14*24*60*60];
        NSString *strToday2 = [dateFormatter stringFromDate:today2];
        NSString *strTodaySub14 = [dateFormatter stringFromDate:todaySub14];
        NSDate *dateToday2 = [dateFormatter dateFromString:strToday2];
        NSDate *dateTodaySub14 =[dateFormatter dateFromString:strTodaySub14];

        [cell.VisitImg setHidden:YES];
        if(cell.NextJoin.text.length > 0){
            if(([dateCell compare:dateTodayAdd1] == NSOrderedDescending ||
                [dateCell compare:dateTodayAdd1] == NSOrderedSame)
               &&
               ([dateCell compare:dateTodayAdd14] == NSOrderedAscending ||
                [dateCell compare:dateTodayAdd14] == NSOrderedSame)
               ){
                [cell.VisitImg setHidden:NO];
                cell.VisitImg.image = [UIImage imageNamed:@"bg_green_light.png"];
                cell.NextJoin.textColor = [UIColor greenColor];
                //    }else if(dateCell >= dateTodaySub14 && dateCell <= dateToday2){
                //[cell.NextJoin setFont:[UIFont boldSystemFontOfSize:12]];
            }else if(([dateCell compare:dateTodaySub14] == NSOrderedDescending ||
                      [dateCell compare:dateTodaySub14] == NSOrderedSame)
                     &&
                     ([dateCell compare:dateToday2] == NSOrderedAscending ||
                      [dateCell compare:dateToday2] == NSOrderedSame)
                     ){
                 [cell.VisitImg setHidden:NO];
                cell.VisitImg.image = [UIImage imageNamed:@"bg_red_light.png"];
                cell.NextJoin.textColor = [UIColor redColor];
                //[cell.NextJoin setFont:[UIFont boldSystemFontOfSize:12]];
            }else{
                [cell.VisitImg setHidden:YES];
                cell.NextJoin.textColor = [UIColor colorWithRed:(104/255.0)
                                                          green:(104/255.0) blue:(104/255.0) alpha:1.0];
            }
        }else{
            [cell.VisitImg setHidden:YES];
            cell.NextJoin.textColor = [UIColor colorWithRed:(104/255.0)
                                                      green:(104/255.0) blue:(104/255.0) alpha:1.0];
        }
        return cell;
    }else if(tableView == _NameSortTableView){
         NameSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameSortCell" forIndexPath:indexPath];
         cell.NameSortLabel.text = self.NameArray[indexPath.row][@"value"];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(tableView == _CusInfoListTableView){
        self.CusNum = self.resultArr[indexPath.row][@"customerNumber"];
        
        if(self.CusNum != nil){
            NSDictionary *dictionary = @{
                                          @"branchCode":appDelegate.branchCode,
                                          @"staffCode":appDelegate.staffCode,
                                          @"customerNumber":self.resultArr[indexPath.row][@"customerNumber"]
                                         //@"dbSchemaName":self.LoginDic[@"authorization"][@"dbSchemaName"]
                                                                          };
            [DataController dbConn:appDelegate.authId dic:dictionary initMode:6 complete:^(NSDictionary * _Nonnull result) {
                NSLog(@"cus成功");
                NSDictionary *cusDic;
                cusDic = result;
                [self.CusInfoConVC test:cusDic CustomerNumber:self.CusNum];
                [self.CusListConVC PromisingInformation:result];
            }];
            dictionary = @{
                                @"branchCode":appDelegate.branchCode,
                                          
                                @"customerNumber":self.resultArr[indexPath.row][@"customerNumber"],
                                          
                                //@"dbSchemaName":self.LoginDic[@"authorization"][@"dbSchemaName"]
                                        };
            [DataController dbConn:appDelegate.authId dic:dictionary initMode:9 complete:^(NSDictionary * _Nonnull result) {
                [self.CusListConVC conNego:result];
                [self.NegoRegistVC RegistReq:dictionary[@"customerNumber"]];
            }];
 }
    }else if(tableView == _NameSortTableView){
        self.arrayCp = self.array;
        if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"あ"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ｱ-ｵ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
              [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"た"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ﾀ-ﾄ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"か"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ｶ-ｺ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"さ"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ｻ-ｿ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"な"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ﾅ-ﾉ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"は"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ﾊ-ﾎ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"ま"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ﾏ-ﾓ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"や"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ﾔ-ﾖ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"ら"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ﾗ-ﾛ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"わ"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[ﾜ-ｦ].+"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"他"]){
            NSPredicate * predicate = [NSPredicate predicateWithFormat : @"nameKana MATCHES %@",@"^[^ｱ-ﾝﾞﾟｧ-ｫｬ-ｮｰ｡｢｣､].+|^[a-zA-Z0-9]{0}$"];
            self.arrayCp = [self.array filteredArrayUsingPredicate : predicate];
            [self filterCheck];
        }else if([self.NameArray[indexPath.row][@"value"]isEqualToString:@"全"]){
            self.arrayCp = self.array;
            [self filterCheck];
        }
    }

}
- (IBAction)LogOutBtnDown:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (CusInfoConViewController *)CusInfoConVC {
    for (CusInfoConViewController *CusInfoCon in self.childViewControllers) {
        if ([CusInfoCon isKindOfClass:[CusInfoConViewController class]]){
            return CusInfoCon;
        }
    }
    return nil;
}

- (CusListConViewController *)CusListConVC {
    for (CusListConViewController *CusListCon in self.childViewControllers) {
        if ([CusListCon isKindOfClass:[CusListConViewController class]]){
            return CusListCon;
        }
    }
    return nil;
}

- (IBAction)reCordBtn:(id)sender {
    self.CusInfoConView.hidden = YES;
    self.CusListConView.hidden = NO;
    UIImage *NegoBtnImage = [UIImage imageNamed:@"tab_on_negotiate@2x.png"];
    [self.NegoImg setBackgroundImage:NegoBtnImage forState:UIControlStateNormal];
    
    UIImage *ContractBtnImage = [UIImage imageNamed:@"tab_off_customer@2x.png"];
    [self.ContractImg setBackgroundImage:ContractBtnImage forState:UIControlStateNormal];
    self.ContractLabel.textColor = [UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1.0];
    
     self.NegoLabel.textColor = [UIColor colorWithRed:(95/255.0) green:(142/255.0) blue:(174/255.0) alpha:1.0];
    
}
- (IBAction)contractBtn:(id)sender {
    self.CusInfoConView.hidden = NO;
    self.CusListConView.hidden = YES;
    
    UIImage *NegoBtnImage = [UIImage imageNamed:@"tab_off_negotiate@2x.png"];
    [self.NegoImg
     setBackgroundImage:NegoBtnImage forState:UIControlStateNormal];
    
    UIImage *ContractBtnImage = [UIImage imageNamed:@"tab_on_customer@2x.png"];
    [self.ContractImg setBackgroundImage:ContractBtnImage forState:UIControlStateNormal];
    
    self.ContractLabel.textColor = [UIColor colorWithRed:(95/255.0) green:(142/255.0) blue:(174/255.0) alpha:1.0];
    
    self.NegoLabel.textColor = [UIColor colorWithRed:(153/255.0) green:(153/255.0) blue:(153/255.0) alpha:1.0];
}

- (NegoRegistViewController *)NegoRegistVC {
    for (NegoRegistViewController *NegoRegist in self.childViewControllers) {
        if ([NegoRegist isKindOfClass:[NegoRegistViewController class]]){
            return NegoRegist;
        }
    }
    return nil;
}

-(void)filterCheck{
    self.mutable = [[NSMutableArray alloc] init];
    if(_Atoggle){
        [_mutable addObject:@"A"];
    }
    if(_Btoggle){
        [_mutable addObject:@"B"];
       
    }
    if(_Ctoggle){
        [_mutable addObject:@"C"];
        
    }
    if(_Dtoggle){
        [_mutable addObject:@"D"];
       
    }
    if(_Etoggle){
        [_mutable addObject:@"E"];
        
    }
    if(_Ytoggle){
        [_mutable addObject:@"Y"];
        
    }
    if(_Ztoggle){
        [_mutable addObject:@"Z"];
       
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rank IN %@", _mutable];
    self.filterResultArr = [self.arrayCp filteredArrayUsingPredicate : predicate];
    self.resultArr = self.filterResultArr;
    
    if(self.resultArr.count == 0) {
      [self.CusInfoConVC InfoClear];
      [self.CusListConVC ListClear];
    }
    if(self.resultArr != nil){
        [self.CusInfoListTableView reloadData];
    }
    if(_resultArr.count > 0){
        [self firstCheck];
    }
}

- (IBAction)ArankBtn:(id)sender {
    NSInteger tag = [sender tag];
    switch (tag) {
        case 0:
            if(_Atoggle){
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_a_off@2x.png"];
                [self.ArankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Atoggle = false;
            }else{
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_a_on@2x.png"];
                [self.ArankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Atoggle = true;
            }
            break;
        case 1:
            if(_Btoggle){
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_b_off@2x.png"];
                [self.BrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Btoggle = false;
            }else{
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_b_on@2x.png"];
                [self.BrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Btoggle = true;
            }
            break;
        case 2:
            if(_Ctoggle){
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_c_off@2x.png"];
                [self.CrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Ctoggle = false;
            }else{
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_c_on@2x.png"];
                [self.CrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Ctoggle = true;
            }
            break;
        case 3:
            if(_Dtoggle){
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_d_off@2x.png"];
                [self.DrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Dtoggle = false;
            }else{
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_d_on@2x.png"];
                [self.DrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Dtoggle = true;
            }
            break;
        case 4:
            if(_Etoggle){
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_e_off@2x.png"];
                [self.ErankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Etoggle = false;
            }else{
               UIImage *rankBtnImage = [UIImage imageNamed:@"filter_e_on@2x.png"];
                [self.ErankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Etoggle = true;
            }
            break;
        case 5:
            if(_Ytoggle){
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_y_off@2x.png"];
                [self.YrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Ytoggle = false;
            }else{
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_y_on@2x.png"];
                [self.YrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Ytoggle = true;
            }
            break;
        case 6:
            if(_Ztoggle){
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_z_off@2x.png"];
                [self.ZrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Ztoggle = false;
            }else{
                UIImage *rankBtnImage = [UIImage imageNamed:@"filter_z_on@2x.png"];
                [self.ZrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
                self.Ztoggle = true;
            }
            break;
        default:
            break;
    }
    [self filterCheck];
}
- (IBAction)AllOnBtn:(id)sender {
   
    self.Atoggle = true;
    self.Btoggle = true;
    self.Ctoggle = true;
    self.Dtoggle = true;
    self.Etoggle = true;
    self.Ytoggle = true;
    self.Ztoggle = true;

    UIImage *rankBtnImage;
    rankBtnImage = [UIImage imageNamed:@"filter_a_on@2x.png"];
    [self.ArankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_b_on@2x.png"];
    [self.BrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_c_on@2x.png"];
    [self.CrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_d_on@2x.png"];
    [self.DrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_e_on@2x.png"];
    [self.ErankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_y_on@2x.png"];
    [self.YrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_z_on@2x.png"];
    [self.ZrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    
    [self filterCheck];
}

- (IBAction)AllOff:(id)sender {
    self.Atoggle = false;
    self.Btoggle = false;
    self.Ctoggle = false;
    self.Dtoggle = false;
    self.Etoggle = false;
    self.Ytoggle = false;
    self.Ztoggle = false;
    
    UIImage *rankBtnImage;
    rankBtnImage = [UIImage imageNamed:@"filter_a_off@2x.png"];
    [self.ArankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_b_off@2x.png"];
    [self.BrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_c_off@2x.png"];
    [self.CrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_d_off@2x.png"];
    [self.DrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_e_off@2x.png"];
    [self.ErankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_y_off@2x.png"];
    [self.YrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    rankBtnImage = [UIImage imageNamed:@"filter_z_off@2x.png"];
    [self.ZrankBtn setBackgroundImage:rankBtnImage forState:UIControlStateNormal];
    
    [self filterCheck];
}

@end
