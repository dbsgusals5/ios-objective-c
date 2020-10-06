//
//  NumberInputTextField.h
//  NumberInputView
//
//  Created by Foresight System TADA Tetsuya on 2014/09/09.
//  Copyright (c) 2014年 Fujitsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberInputView.h"

/**
 @brief NumberInputView TextField
 @details NumberInputViewをInputViewとしたTextField。\n
 UITextFieldのクラスを本クラスにすることで、キーボードがテンキーパッドとなる。
 */
@interface NumberInputTextField : UITextField <NumberInputViewDelegate>

@end
