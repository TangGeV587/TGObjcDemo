//
//  TestCell.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/4.
//

#import <UIKit/UIKit.h>

@class TestModel;
NS_ASSUME_NONNULL_BEGIN

@interface TestCell : UITableViewCell

/** 数据模型 */
@property(nonatomic, strong) TestModel *model;

@end

NS_ASSUME_NONNULL_END
