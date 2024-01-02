//
//  MainViewController.m
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/02.
//

#import "ReactiveObjC.h"
#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "]
        .rac_sequence
        .signal;
    
    [letters subscribeNext:^(NSString *x) {
        NSLog(@"%@", x);
    }];
}

@end
