//
//  TodoRepository.h
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/23.
//

#import <Foundation/Foundation.h>
#import "TodoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoRepository : NSObject

@property NSMutableArray* todoModels;
@property TodoModel* modelToInsert;

+ (TodoRepository *)shared;
- (TodoModel *)getModeltoInsert;
- (void)clearModelToIndex;
- (BOOL)insertNew:(id)todo;
- (BOOL)insertNew:(id)todo at:(int)index;

@end

NS_ASSUME_NONNULL_END
