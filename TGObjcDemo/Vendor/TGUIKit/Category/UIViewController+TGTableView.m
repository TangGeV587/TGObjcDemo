//
//  UIViewController+TGTableView.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import "UIViewController+TGTableView.h"
#import "TGCommonMacro.h"
#import "TGTableView.h"

@implementation UIViewController (TGTableView)

- (TGTableView *)setupTableViewWithStyle:(UITableViewStyle)style {
    CGFloat tabViewH = TGScreenH - TGStatusHeight() - TG_SAFE_Bottom;
    CGRect frame = CGRectMake(0, 0, TGScreenW, tabViewH);
    TGTableView *tableView = [[TGTableView alloc]initWithFrame:frame style:style];
    [self.view addSubview:tableView];
    return tableView;
}

@end
