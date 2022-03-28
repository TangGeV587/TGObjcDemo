//
//  RacListTableViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/25.
//

#import "RacListTableViewController.h"
#import "TGDataItem.h"

@interface RacListTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation RacListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)setupUI {
    self.navigationItem.title = @"RAC Demo";
    self.tableView.tableFooterView =  [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 60;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TGObjcDemoCell"];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TGObjcDemoCell"];
    TGDataItem *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TGDataItem *item = self.dataSource[indexPath.row];
    Class clazz = NSClassFromString(item.className);
    UIViewController *vc = [[clazz alloc] init];
    vc.title = item.title;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
            [[TGDataItem alloc] init:@"Subject" withClassName:@"RACSubjectViewController"],
        ];
    }
    return _dataSource;
}




@end
