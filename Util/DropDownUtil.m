//
//  DropDownUtil.m
//  HousingPortal
//
//  Created by アルファー on 2019/02/01.
//  Copyright © 2019年 alpha. All rights reserved.
//

#import "DropDownUtil.h"

@interface DropDownUtil () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) DropDownCompletion requestCompletion;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;

@property (weak, nonatomic) IBOutlet UITextField *selectedTextField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

@property (strong, nonatomic) NSArray *selectArray;

- (IBAction)selectListActive:(id)sender;
@end

@implementation DropDownUtil

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
-(void) dropDownShow: (BOOL) showFlg {
  CGRect frame = self.view.superview.frame;
    
    CGFloat hight = [_selectArray count] * 30.0f;
    if(showFlg) {
        frame.size.height = frame.size.height + hight;
    } else {
        frame.size.height = frame.size.height - hight;
    }
    [UIView animateWithDuration:0 animations:^{
        if(showFlg) {
            self.arrowImg.transform = CGAffineTransformMakeRotation(180 * M_PI / 180);
        } else {
            self.arrowImg.transform = CGAffineTransformMakeRotation(0 * M_PI / 180);
        }
        self.view.superview.frame = frame;
    } completion:^(BOOL finished) {
        self.selectView.hidden = !showFlg;
    }];
}

- (void) targetView : (UIView*) view
         withOption : (NSArray*) array
       withSelected : (NSString*) value
         completion : (DropDownCompletion)completion {
    self.view.superview.frame = view.frame;
    
    
    _selectArray = array.mutableCopy;
    CGFloat hegigt = [_selectArray count] * 30.0f;
    
    CGRect selectViewFrame = _selectView.frame;
    selectViewFrame.size.height = hegigt;
    [_selectView setFrame:selectViewFrame];
    
    CGRect selectTableViewFrame = _selectTableView.frame;
    selectTableViewFrame.size.height = hegigt;
    [_selectTableView setFrame:selectTableViewFrame];
    
    _selectView.hidden = YES;
    _requestCompletion = completion;
    
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.0 animations:^{
        [wself.selectTableView reloadData];
    } completion:^(BOOL finished) {
        // 初期値がある場合、画面に設定する
        for (int i = 0; i < [wself.selectArray count]; i++) {
            NSDictionary *dic = [wself.selectArray objectAtIndex:i];
            if([dic[@"key"] isEqualToString:value] || [dic[@"value"] isEqualToString:value]) {
                wself.selectedTextField.text = dic[@"value"];
                wself.requestCompletion(dic);
                break;
            }
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_selectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_selectTableView]) {
        NSDictionary *dictionary = _selectArray[indexPath.row];
        DropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectLabel.text = dictionary[@"value"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = _selectArray[indexPath.row];
    self.selectedTextField.text = dictionary[@"value"];
    [self dropDownShow:NO];
    _requestCompletion(dictionary);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField tag]) {
        [textField setTag:NO];
        return NO;
    }
    
    [self dropDownShow:_selectView.isHidden?YES: NO];
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [textField setTag:YES];
    _requestCompletion(nil);
    return YES;
}

#pragma mark - Action
- (IBAction)selectListActive:(id)sender {
   [self dropDownShow:_selectView.isHidden?YES: NO];
}

#pragma mark - public
+ (void)target:(UIViewController *)target withSoureView:(UIView *)soureView withOptionList:(NSArray *)optionArray withSelectedValue:(NSString *)selectedValue completion:(DropDownCompletion)completion {
    DropDownUtil *dropDown =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DropDown"];
    [dropDown targetView:soureView withOption:optionArray withSelected:selectedValue completion:completion];
    [soureView addSubview:dropDown.view];
    [target addChildViewController:dropDown];
}

@end

@interface DropDownCell()

@end

@implementation DropDownCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

