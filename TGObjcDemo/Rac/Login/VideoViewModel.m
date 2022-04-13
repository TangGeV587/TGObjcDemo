//
//  VideoViewModel.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/12.
//

#import "VideoViewModel.h"
#import "VideoListTableViewCell.h"
#import "TGDemoNetHandle.h"
#import <YYModel.h>
@interface VideoViewModel ()

@property(nonatomic,strong)NSMutableArray *videoModels;
@property(nonatomic,assign)NSInteger currentPage;

@end

@implementation VideoViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self setupSignal];
    }
    return self;
}

- (void)setupSignal {
    
    self.videoListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSDictionary *inputData = (NSDictionary *)input;
            BOOL headerRefresh = [inputData[@"headerRefresh"] boolValue];
            NSInteger requestPage = headerRefresh ? 0 : self.currentPage + 1;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSString *paramPage = [NSString stringWithFormat:@"%ld",requestPage];
            [params setObject:paramPage forKey:@"page"];
            [TGDemoNetHandle requestForVideoList:params response:^(BOOL success, id  _Nullable data) {
                if (success) {
                    VideoListDataModel *videoListDataModel = [VideoListDataModel yy_modelWithJSON:data];
                    if(videoListDataModel.videos.count >0){
                        if(requestPage == 0){
                            self.currentPage = 0;
                            [self.videoModels removeAllObjects];
                        }else{
                            self.currentPage = requestPage;
                        }
                        [self.videoModels addObjectsFromArray:videoListDataModel.videos];
                    }
                }else {
                    //错误信息处理
//                    NSString *data = data[@"errorMsg"];
                }
                [subscriber sendNext:data];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
    
    
    [[self.videoListCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        [self.resultSubject sendNext:x];
    }];
    
    [[self.videoListCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            NSLog(@"show loading ....");
        }else {
            NSLog(@"hide loading ....");
        }
    }];
}

#pragma mark - table view datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"VideoListTableViewCellID";
     VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [VideoListTableViewCell getVideoListTableViewCell];
    }
    cell.videoListModel = self.videoModels[indexPath.row];
    return cell;
}

#pragma mark - table view deledate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



#pragma mark - Getter && Setter
- (NSMutableArray *)videoModels{
    if (!_videoModels) {
        _videoModels = [NSMutableArray array];
    }
    return _videoModels;
}

- (RACSubject *)resultSubject {
    if (_resultSubject == nil) {
        _resultSubject = [RACSubject subject];
    }
    return _resultSubject;
}


@end
