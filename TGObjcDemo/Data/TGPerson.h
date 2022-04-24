//
//  TGPerson.h
//  RuntiemDemo
//
//  Created by e-zhaoyutang on 2022/4/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TGPersonDelegate <NSObject>

- (void)goToSchool;

@end


NS_ASSUME_NONNULL_BEGIN

@interface TGPerson : NSObject<TGPersonDelegate>
{
    NSString *nick;
}

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *name;

- (void)run;
- (void)eat;

@end

NS_ASSUME_NONNULL_END
