//
//  main.m
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/02.
//

#import <UIKit/UIKit.h>
#import "Resources/AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
