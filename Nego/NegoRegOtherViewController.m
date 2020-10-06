//
//  NegoRegOtherViewController.m
//  iPadCourceYun
//
//  Created by alpha on 2019/09/24.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "NegoRegOtherViewController.h"
#import "RegOtherTableViewCell.h"

@interface NegoRegOtherViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *NegoOtherTableView;
@property (copy, nonatomic) NegoOthersCompletion requestCompletion;

@end

@implementation NegoRegOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NegoOtherTableView.delegate = self;
    self.NegoOtherTableView.dataSource = self;
    
    self.negoRegOthersArray = @[
                                  @{@"value":@"ご主人"},
                                  @{@"value":@"奥様"},
                                  @{@"value":@"父"},
                                  @{@"value":@"母"},
                                  @{@"value":@"子供"},
                                  @{@"value":@"その他"}
                              ];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [self.negoRegDivArray count];
    return [self.negoRegOthersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NegoOtherCell" forIndexPath:indexPath];
    
    cell.OtherContent.text = self.negoRegOthersArray[indexPath.row][@"value"];
    return cell;
}

- (void) closePopup : (NSString *) selectedOthers {
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        wself.requestCompletion(selectedOthers);
    }];
}

+ (void)target:(UIViewController *)target soureView:(UIView *)view completion:(NegoOthersCompletion)completion {
    
    NegoRegOtherViewController *NegoOthers = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NegoOther"];
    NegoOthers.modalPresentationStyle = UIModalPresentationPopover;
    NegoOthers.requestCompletion = completion;
    NegoOthers.preferredContentSize = CGSizeMake(90, 138);
    
    UIPopoverPresentationController *popover = NegoOthers.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popover.sourceView = view;
    popover.sourceRect = view.bounds;
    [target presentViewController:NegoOthers animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self closePopup:self.negoRegOthersArray[indexPath.row][@"value"]];
}
@end
