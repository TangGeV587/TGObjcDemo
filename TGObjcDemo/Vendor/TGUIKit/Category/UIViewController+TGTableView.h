//
//  UIViewController+TGTableView.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import <UIKit/UIKit.h>
@class TGTableView;
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TGTableView)

- (TGTableView *)setupTableViewWithStyle:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
