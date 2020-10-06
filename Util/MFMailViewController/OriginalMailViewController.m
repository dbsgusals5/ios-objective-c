//
//  OriginalMailViewController.m
//  mock02
//
//  Created by ALiMac11 on 2015/04/21.
//  Copyright (c) 2015年 hama. All rights reserved.
//

#import "OriginalMailViewController.h"

@interface OriginalMailViewController ()

@end

@implementation OriginalMailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
     // 色調設定
     // 参考 http://stackoverflow.com/questions/20768736/mfmailcomposeviewcontroller-appearance-settintcolor-getting-lost-ios-7
     // 結果 NG
     [self.navigationBar setTintColor:[UIColor blueColor]];
     [self.navigationBar setBarTintColor:[UIColor blueColor]];
     */
    
    /*
     // custom「戻るボタン」 test
     // 結果 NG
     self.navigationItem.leftBarButtonItem
     = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_return.png"]
     style:UIBarButtonItemStylePlain
     target:self action:@selector(backAction)];
     [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     // ↓消す
     self.navigationItem.backBarButtonItem = nil;
     */
    
    /*
     // custom「戻るボタン」2 test
     // 参考 http://rananculus.com/ios7-back
     // 結果 NG
     UIButton* customView = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 70, 50 )];
     [customView setBackgroundImage:[UIImage imageNamed:@"btn_return.png"] forState:UIControlStateNormal];
     [customView addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
     self.navigationItem.leftBarButtonItem = buttonItem;
     */
    
    //self.navigationController.navigationBar.tintColor = [UIColor yellowColor]; // NG
    //[self.navigationBar setTintColor:[UIColor redColor]]; // NG
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     // ボタンの文字色だけ変更できる模様
     [self.navigationBar setBarTintColor:[UIColor redColor]]; // NG
     */
    //[self.navigationBar setTintColor:[UIColor darkGrayColor]]; // OK ==> NG
    
    [self setExclusiveTouch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//同時押し対応
- (void)setExclusiveTouch
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            view.exclusiveTouch = YES;
        }
    }
}

@end
