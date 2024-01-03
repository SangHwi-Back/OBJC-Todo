//
//  MainViewController.h
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/02.
//

#import <UIKit/UIKit.h>
#import "TodoModel.h"

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *todos;

@end

