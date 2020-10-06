//
//  CustomerViewController.m
//  iPadCourceYoon
//
//  Created by alpha on 2019/09/04.
//  Copyright © 2019 alpha. All rights reserved.
//

#import "CustomerViewController.h"

@interface CustomerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *allCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *allRelBtn;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *NewBtn;




@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allRelBtn.layer.masksToBounds = YES;
    self.allCheckBtn.layer.masksToBounds = YES;
    self.logOutBtn.layer.masksToBounds = YES;
    self.delBtn.layer.masksToBounds = YES;
    self.updateBtn.layer.masksToBounds = YES;
    self.NewBtn.layer.masksToBounds = YES;
  
   

    

    
    self.allRelBtn.layer.cornerRadius = 5;
    self.allCheckBtn.layer.cornerRadius = 5;
    self.logOutBtn.layer.cornerRadius = 5;
    self.delBtn.layer.cornerRadius = 5;
    self.updateBtn.layer.cornerRadius = 5;
    self.NewBtn.layer.cornerRadius = 5;

    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
