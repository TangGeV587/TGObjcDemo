//
//  TestCell.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/4.
//

#import "TestCell.h"
#import "TestModel.h"

@interface TestCell ()

@property(nonatomic, weak)UILabel *msgLabel;

@end

@implementation TestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor yellowColor];
    UILabel *msgLabel = [[UILabel alloc]init];
    msgLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = [UIFont systemFontOfSize:22];
    [self.contentView addSubview:msgLabel];
    self.msgLabel = msgLabel;
}

-(void)setModel:(TestModel *)model{
    _model = model;
    if([model isKindOfClass:[TestModel class]]){
        self.msgLabel.text = model.msg;
    }
}

@end
