//
//  TGView.m
//  ReactCoCoaDemo
//
//  Created by e-zhaoyutang on 2021/7/1.
//

#import "TGView.h"

@implementation TGView


- (void)sendAction:(NSString *)text {
    //什么都不做
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sendAction:@"xxxxx"];
//    [self.subject sendNext:@"上班了"];
}



#pragma mark - lazy

- (RACSubject *)subject {
    if (_subject == nil) {
        _subject = [[RACSubject alloc] init];
    }
    return _subject;
}


@end
