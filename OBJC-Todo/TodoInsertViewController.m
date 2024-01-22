//
//  TodoInsertViewController.m
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/13.
//

#import "TodoInsertViewController.h"
#import "TodoRepository.h"

@implementation TodoInsertViewController

@synthesize todo;
@synthesize imageView;
@synthesize titleField;
@synthesize contentsTextView;
@synthesize previewCell;
@synthesize buttonSubmit;
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

- (MainTableViewCell *)getPreviewCell {
  return [[previewCell subviews] firstObject];
}

@end
