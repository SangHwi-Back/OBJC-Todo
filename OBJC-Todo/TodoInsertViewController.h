//
//  TodoInsertViewController.h
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/13.
//

#import <UIKit/UIKit.h>
#import "MainTableViewCell.h"
#import "TodoModel.h"

@interface TodoInsertViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property TodoModel *todo;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentsTextView;
@property (weak, nonatomic) IBOutlet UIView *previewCell;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;
@property int lengthLimit;

@end
