//
//  TodoModel.h
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/03.
//

#import <Foundation/Foundation.h>

@interface TodoModel : NSObject
{
    NSData *imageData;
    NSString *title;
    NSString *contents;
    NSDate *date;
}

@property NSData *imageData;
@property NSString *title;
@property NSString *contents;
@property NSDate *date;

@end
