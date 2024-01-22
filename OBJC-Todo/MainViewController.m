//
//  MainViewController.m
//  OBJC-Todo
//
//  Created by 백상휘 on 2024/01/02.
//

#import "ReactiveObjC.h"
#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "TodoModel.h"
#import "TodoRepository.h"

@implementation MainViewController

@synthesize todos, tableView;

- (void)loadView
{
  [super loadView];
  
  UINib *nib = [UINib nibWithNibName:@"MainTableViewCell" bundle:nil];
  [tableView registerNib:nib forCellReuseIdentifier:@"MainTableViewCell"];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  todos = [TodoRepository.shared todoModels];
  [tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
  [tableView setDelegate:self];
  [tableView setDataSource:self];
}

- (void)viewWillDisappear:(BOOL)animated {
  [tableView setDelegate:nil];
  [tableView setDataSource:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"
                                                            forIndexPath:indexPath];
  TodoModel* model = [TodoRepository.shared.todoModels objectAtIndex:[indexPath row]];
  
  [cell.titleLabel setText:model.title];
  [cell.contentsLabel setText:model.contents];
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
