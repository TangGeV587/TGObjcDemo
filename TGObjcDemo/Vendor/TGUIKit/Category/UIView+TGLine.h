//
//  UIView+TGLine.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TGViewLinePosition) {
    TGViewLinePositionNone                  = 0,
    TGViewLinePositionLeft                  = 1 << 0,
    TGViewLinePositionRight                 = 1 << 1,
    TGViewLinePositionBottom                = 1 << 2,
    TGViewLinePositionTop                   = 1 << 3,

};


@interface UIView (TGLine)

@property (nonatomic, strong)UIView* tg_leftLine;
@property (nonatomic, strong)UIView* tg_rightLine;
@property (nonatomic, strong)UIView* tg_topLine;
@property (nonatomic, strong)UIView* tg_bottomLine;
@property (nonatomic, assign)TGViewLinePosition tg_position;

@property (nonatomic, assign)UIEdgeInsets tg_lineEdgeInsets;
@property (nonatomic, assign)CGFloat tg_lineWidth;
@property (nonatomic, strong)UIColor* tg_lineColor;

@property (nonatomic, assign)UIEdgeInsets tg_lineTopEdgeInsets;
@property (nonatomic, assign)UIEdgeInsets tg_lineLeftEdgeInsets;
@property (nonatomic, assign)UIEdgeInsets tg_lineBottomEdgeInsets;
@property (nonatomic, assign)UIEdgeInsets tg_lineRightEdgeInsets;


-(void)tg_showLintWithPosition:(TGViewLinePosition)positionl;

@end

