//
//  TestViewController.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import "TestViewController.h"
#import "UIViewController+TGTableView.h"
#import "TGTableView.h"
#import "TestModel.h"
#import "TestCell.h"
#import "TestHeaderSectionView.h"
#import "TGCommonMacro.h"

@interface TestViewController ()

@property(nonatomic, strong) TGTableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TestViewController

#pragma mark view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
}

- (void)setupUI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(cleanAll)];
    
   TGTableView *tableView = [self setupTableViewWithStyle:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor lightGrayColor];
    tableView.cellReuseIdentifyList = @[NSStringFromClass([TestCell class])];
    tableView.sectionHeaderReuseIdList = @[NSStringFromClass([TestHeaderSectionView class])];
    tableView.isMuiltySection = YES;
    TGWeakSelf
    [tableView addMJHeader:^{
      [weakSelf reqDataList];
    }];
    
    [tableView addMJFooter:^{
      [weakSelf reqDataList];
    }];
    
    tableView.reuseIdentifyBlock = ^NSString * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        return NSStringFromClass([TestCell class]);
    };
    
    tableView.configCellBlock = ^(NSIndexPath *indexPath, UITableViewCell * cell, id  model) {
       ((TestCell *)cell).model = model;
    };
    
    
    /** table view  delegate */
    
    tableView.heightForRowBlock = ^CGFloat(NSIndexPath * _Nonnull indexPath) {
        return 60;
    };
    
    tableView.didSelectedBlock = ^(NSIndexPath *indexPath, TestModel *model, UITableViewCell *cell) {
        NSLog(@"选中了%zd行\n内容:%@",indexPath.row,model.msg);
    };
    
    //headerView
    tableView.sectionHeaderViewReuseIdBlock = ^NSString * _Nonnull(NSInteger section) {
        return NSStringFromClass([TestHeaderSectionView class]);
    };
    
    tableView.configSectionHeaderViewBlock = ^(UIView *sectionHeaderView, NSInteger section, id content) {
        ((TestHeaderSectionView *)sectionHeaderView).content = [NSString stringWithFormat:@"第%zd组组头",section + 1];
    };
    
    tableView.sectionHeaderHeightBlock = ^CGFloat(NSInteger section) {
        return 30;
    };
    
    //滑动删除
    tableView.sideDeleteBlock = ^NSArray<UITableViewRowAction *> *(NSIndexPath *indexPath) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            TGLog(@"删除第%zd行",indexPath.row);
        }];
        return @[deleteAction];
    };
    
    self.tableView = tableView;
}

#pragma mark - fetch data
- (void)setupData {
    for(NSUInteger i = 0; i < 2;i++){
        NSMutableArray *sectionArr = [NSMutableArray array];
    for(NSUInteger j = 0; j < 3;j++){
        TestModel *model = [[TestModel alloc]init];
        model.title = @"Test";
        model.msg = [NSString stringWithFormat:@"第%lu行",j];
        [sectionArr addObject:model];
    }
    [self.dataSource addObject:sectionArr];
    }
    self.tableView.dataList = self.dataSource;
    [self.tableView reloadData];
}

-(void)reqDataList{
    TGWeakSelf
    [self reqLocalDtatWithParam:@{@"pageNo" : @(self.tableView.pageNo),@"pageCount" : @(self.tableView.pageCount)} resultBlock:^(BOOL result,id backData) {
        TGStrongSelf
        if(result){
            //请求成功
            [strongSelf.tableView.dataList addObject:backData];
        }
        //更新当前TableView状态
        [strongSelf.tableView updateTabViewStatus:result errDic:backData backSel:@selector(reqDataList)];
    }];
}

-(void)reqLocalDtatWithParam:(NSDictionary *)param resultBlock:(void(^)(BOOL,id))resultBlock{
    NSMutableArray *localDatasArr = [NSMutableArray array];
    for(NSUInteger i = 0;i < 3;i++){
        TestModel *model = [[TestModel alloc]init];
        model.title = @"Test";
        model.msg = [NSString stringWithFormat:@"测试数据-%lu",i];
        [localDatasArr addObject:model];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        resultBlock(YES,localDatasArr);
    });
}

#pragma mark action

-(void)cleanAll{
    [self.tableView.dataList removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark 懒加载

- (NSMutableArray *)dataSource {
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSArray *)reuseIndentifyList {
    return @[@"TestCell"];
}

@end
