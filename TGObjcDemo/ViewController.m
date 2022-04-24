//
//  ViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/24.
//

#import "ViewController.h"
#import "TGDataItem.h"
#import <objc/runtime.h>

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
   
}

static inline void swizzling_ExchangeMethod(Class clazz,SEL originSelector,SEL swizzledSelector) {
    
   Method originMehtod =  class_getClassMethod(clazz, originSelector);
   Method swizzledMethod = class_getClassMethod(clazz, swizzledSelector);
   BOOL result = class_addMethod(clazz, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (result) {
//        class_replaceMethod(clazz, originMehtod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    }else {
//        method_exchangeImplementations(originMehtod, swizzledMethod);
    }
}



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, screenW, self.view.frame.size.height);
}

- (void)setupUI {
    self.navigationItem.title = @"Demo首页";
    [self.view addSubview:self.tableView];
}

#pragma mark Private


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
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *footView =  [[UIView alloc] init];
        _tableView.tableFooterView = footView;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TGObjcDemoCell"];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
            [[TGDataItem alloc] init:@"Rac" withClassName:@"RacListTableViewController"],
            [[TGDataItem alloc] init:@"RunTime" withClassName:@"TGRuntimeListController"],
        ];
    }
    return _dataSource;
}


@end
