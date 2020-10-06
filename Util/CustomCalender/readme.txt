
①CustomCalenderフォルダをプロジェクトに追加

②projectファイル -> Target -> Build Phases -> Compile Source　の
	UICCalendarPickerDateButton.m
	UICCalendarPicker.m
	上記２つのファイルの Compiler Flages に -fno-objc-arc を入力

③CustomCalender.hをインポート

④UITextFieldDelegateを実装する(textfield.delegate = self)

⑤
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [CustomCalender createCalendarWithTargetTextField:textField format:@"yyyy/MM/dd"
                                             initDate:[CustomCalender createNSDateFromString:textField.text format:@"yyyy/MM/dd"]
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                           completion:^(CustomCalender *calender, NSDate *selectDay) {
                                               textField.text = [CustomCalender createDateStringFromNSDate:selectDay format:@"yyyy/MM/dd"];
                                           }];
    return NO;
}
を追加
