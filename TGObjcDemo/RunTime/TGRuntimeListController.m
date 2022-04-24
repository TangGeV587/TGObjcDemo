//
//  TGRuntimeListController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/24.
//

#import "TGRuntimeListController.h"
#import "TGDataItem.h"

@interface TGRuntimeListController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation TGRuntimeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


- (void)setupUI {
    self.navigationItem.title = @"RAC Demo";
    self.tableView.tableFooterView =  [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 60;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TGObjcDemoRuntimeCell"];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TGObjcDemoRuntimeCell"];
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
            [[TGDataItem alloc] init:@"KVO" withClassName:@"TGKVOController"],
            [[TGDataItem alloc] init:@"私有属性、方法、变量、协议" withClassName:@"TGRumtimeCopyController"],
            //TGRumtimeCopyController
        ];
    }
    return _dataSource;
}

@end
