//
//  TodoInsertViewController.h
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/13.
//

#import <UIKit/UIKit.h>
#import <PhotosUI/PhotosUI.h>
#import "MainTableViewCell.h"
#import "TodoModel.h"

typedef enum: NSUInteger {
  PERMISSION_DENIED = 0,
  PERMISSION_ACCEPTED = 1,
} PHOTO_PERMISSION_STATUS;

@interface TodoInsertViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, PHPickerViewControllerDelegate>

@property TodoModel *todo;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentsTextView;
@property (weak, nonatomic) IBOutlet UIView *previewCell;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;

@property UITapGestureRecognizer *gesture;
@property int lengthLimit;

- (PHOTO_PERMISSION_STATUS)checkAuthorizationForPhotos;

@end
