//
//  MainViewController.m
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/02.
//

#import "ReactiveObjC.h"
#import "MainViewController.h"
#import "MainTableViewCellView.h"
#import "TodoModel.h"

@implementation MainViewController

@synthesize todos, tableView;

- (void)loadView
{
    [super loadView];
    todos = [NSMutableArray array];
    [todos addObject:[[TodoModel alloc] init]];
    [todos addObject:[[TodoModel alloc] init]];
    [todos addObject:[[TodoModel alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [todos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

@end
