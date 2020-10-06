//
//  NegoRegMeansViewController.m
//  iPadCourceYun
//
//  Created by alpha on 2019/09/24.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "NegoRegMeansViewController.h"
#import "RegMeansTableViewCell.h"
@interface NegoRegMeansViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *NegoMeanTableView;
@property (copy, nonatomic) NegoMeansCompletion requestCompletion;
@end

@implementation NegoRegMeansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NegoMeanTableView.delegate = self;
    self.NegoMeanTableView.dataSource = self;
    
    self.negoRegContArray = @[
                          @{@"value":@"訪問"},
                          @{@"value":@"電話"},
                          @{@"value":@"文書"},
                          @{@"value":@"来訪"}
                          ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.negoRegContArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RegMeansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NegoRegCell" forIndexPath:indexPath];
    cell.MeansContent.text = self.negoRegContArray[indexPath.row][@"value"];
    return cell;
}

- (void) closePopup : (NSString *) selectedMeans {
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
            wself.requestCompletion(selectedMeans);
    }];
}

+ (void)target:(UIViewController *)target soureView:(UIView *)view completion:(NegoMeansCompletion)completion {
    
    NegoRegMeansViewController *NegoMeans = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NegoMeans"];
    NegoMeans.modalPresentationStyle = UIModalPresentationPopover;
    NegoMeans.requestCompletion = completion;
    NegoMeans.preferredContentSize = CGSizeMake(98, 92);
    
    UIPopoverPresentationController *popover = NegoMeans.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionLeft;

    popover.sourceView = view;
    popover.sourceRect = view.bounds;
    [target presentViewController:NegoMeans animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self closePopup:self.negoRegContArray[indexPath.row][@"value"]];
}


@end
