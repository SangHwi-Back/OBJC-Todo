//
//  TodoRepository.m
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/23.
//

#import "TodoRepository.h"

@implementation TodoRepository

@synthesize todoModels, modelToInsert;

+ (TodoRepository *)shared {
  static TodoRepository *shared;
  
  static dispatch_once_t oneToken;
  dispatch_once(&oneToken, ^{
    int cnt = 5;
    
    shared = [[TodoRepository alloc] init];
    [shared setTodoModels:[NSMutableArray array]];
    
    for (int i = 0; i < cnt; i++) {
      TodoModel* model = [[TodoModel alloc] init];
      
      [model setTitle:[NSString stringWithFormat:@"title at %d", i]];
      [model setContents:[NSString stringWithFormat:@"contents at %d", i]];
      [shared.todoModels addObject:model];
    }
  });
  
  return shared;
}

- (TodoModel *)getModeltoInsert {
  modelToInsert = [[TodoModel alloc] init];
  return modelToInsert;
}

- (void)clearModelToIndex {
  modelToInsert = nil;
}

- (BOOL)insertNew:(id)todo {
  [todoModels addObject:todo];
  return YES;
}

- (BOOL)insertNew:(id)todo at:(int)index {
  if (todoModels.count < (index + 1)) {
    return NO;
  }
  
  [todoModels insertObject:todo atIndex:index];
  return YES;
}

@end
