//
//  TodoInsertViewController.m
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/13.
//

#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "TodoInsertViewController.h"
#import "TodoRepository.h"

@implementation TodoInsertViewController

@synthesize todo;
@synthesize imageView;
@synthesize titleField;
@synthesize contentsTextView;
@synthesize previewCell;
@synthesize buttonSubmit;
@synthesize gesture;
@synthesize lengthLimit;

- (void)loadView
{
  [super loadView];
  
  UINib *nib = [UINib nibWithNibName:@"MainTableViewCell" bundle:nil];
  NSArray *nibs = [nib instantiateWithOwner:@"MainTableViewCell"
                                    options:nil];
  UIView *first = [nibs firstObject];
  if (first) {
    UIView *first = [nibs firstObject];
    [previewCell addSubview:first];
  }
  
  gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(imageViewTouchUpInside:)];
  [imageView addGestureRecognizer:gesture];
  
  lengthLimit = 15;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [titleField setDelegate:self];
  [contentsTextView setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
  todo = [TodoRepository.shared getModeltoInsert];
  
  [self.titleField addObserver:self forKeyPath:@"text"
            options:(NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionOld)
            context:nil];
  [self.contentsTextView addObserver:self forKeyPath:@"text"
            options:(NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionOld)
            context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
  [TodoRepository.shared clearModelToIndex];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  
  if ([object isEqual:titleField]
      && [keyPath isEqualToString:@"text"]
      && titleField.text) {
    
    [todo setTitle:titleField.text];
    [[self getPreviewCell].titleLabel setText:titleField.text];
  }
  
  if ([object isEqual:contentsTextView]
      && [keyPath isEqualToString:@"text"]) {
    
    [todo setContents:contentsTextView.text];
    [[self getPreviewCell].contentsLabel setText:contentsTextView.text];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { }

// MARK: - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
  [self checkUITextInput:textField
             currentText:[textField text]
             changeRange:range
         replacementText:string];
  return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  [contentsTextView becomeFirstResponder];
  return TRUE;
}

// MARK: - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  
  [self checkUITextInput:textView
             currentText:[textView text]
             changeRange:range
         replacementText:text];
  return TRUE;
}

// MARK: - PHPickerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
  
  [picker dismissViewControllerAnimated:YES completion:nil];
  
  NSItemProvider *provider = [results.firstObject itemProvider];
  if (provider && [provider canLoadObjectOfClass:[UIImage class]]) {
    __weak TodoInsertViewController *weakSelf = self;
    [provider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
      
      if ([object isKindOfClass:[UIImage class]]) {
        UIImage *image = object;
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf.imageView setImage:image];
        });
      } else {
        
        [weakSelf showWarningPhotoAuthorization:@"Failed to load photo. Please contact advisors."];
      }
    }];
  }
}

// MARK: - Action Else

- (IBAction)buttonSubmitTouchUpInsde:(UIButton *)sender
{
  
  [TodoRepository.shared insertNew:todo];
  [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void)checkUITextInput:(id <UITextInput>)elem
             currentText:(NSString *)currentText
             changeRange:(NSRange)range
         replacementText:(NSString *)text
{
  
  NSUInteger ln = range.length;
  
  if ([text isEqual:@""] && ln > 0) { // When Delete
    return;
  }
  
  if ((ln + [text length] + [currentText length]) > lengthLimit) {
    UITextPosition *s = [elem beginningOfDocument];
    UITextPosition *leading = [elem positionFromPosition:s
                                                  offset:(lengthLimit)];
    UITextPosition *trailing = [elem positionFromPosition:s
                                                   offset:(lengthLimit+ln)];
    UITextRange *r = [elem textRangeFromPosition:leading
                                      toPosition:trailing];
    
    [elem replaceRange:r withText:@""];
    [elem setSelectedTextRange:[elem textRangeFromPosition:elem.endOfDocument
                                                toPosition:elem.endOfDocument]];
  }
}

// https://stackoverflow.com/questions/92396/why-cant-variables-be-declared-in-a-switch-statement
- (void)imageViewTouchUpInside:(UITapGestureRecognizer *)gesture
{
  if ([self checkAuthorizationForPhotos] == PERMISSION_DENIED) {
    [self requestPhotoAuthorization];
    return;
  }
  
  PHPickerConfiguration *c = [[PHPickerConfiguration alloc] init];
  [c setSelectionLimit:1];
  [c setFilter:[PHPickerFilter imagesFilter]];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    PHPickerViewController *v = [[PHPickerViewController alloc] initWithConfiguration:c];
    [v setDelegate:self];
    [self presentViewController:v animated:YES completion:nil];
  });
}

- (PHOTO_PERMISSION_STATUS)checkAuthorizationForPhotos
{
  if (@available(iOS 14, *)) {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
    return status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited;
  } else {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status == PHAuthorizationStatusAuthorized;
  }
}

/// It can re-call - (void)imageViewTouchUpInside
- (void)requestPhotoAuthorization
{
  __weak TodoInsertViewController *weakSelf = self;
  
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    switch (status) {
      case PHAuthorizationStatusAuthorized:
      case PHAuthorizationStatusLimited:
        [weakSelf imageViewTouchUpInside:[weakSelf gesture]];
        break;
      default:
        [weakSelf showWarningPhotoAuthorization:@"Album reading authorization is denied. You can't upload your photo."];
        break;
    }
  }];
}

- (void)showWarningPhotoAuthorization:(NSString *)msg
{
  UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Unexpected error"
                                                                      message:msg
                                                               preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* action = [UIAlertAction actionWithTitle:@"Confirmed"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
    [controller dismissViewControllerAnimated:YES completion:nil];
  }];
  
  [controller addAction:action];
  
  __weak TodoInsertViewController *weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf presentViewController:controller animated:YES completion:nil];
  });
}

- (MainTableViewCell *)getPreviewCell {
  return [[previewCell subviews] firstObject];
}

@end
