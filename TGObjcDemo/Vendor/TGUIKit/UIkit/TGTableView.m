//
//  TGTableView.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import "TGTableView.h"
#import "TGUIKitConst.h"
#import "TGCommonMacro.h"
#import "MJRefresh.h"
#import "UIColor+TGHex.h"
#import "UIView+TGHUD.h"
#import "UIView+TGFrame.h"

@interface TGTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy) NSString *noMoreStr;
@property(nonatomic, weak) UIView *noMoreDataView;
@property(nonatomic, assign) MJFooterStyle footerStyle;
@property(nonatomic, assign) BOOL isMJHeaderRef;
@property(nonatomic, strong) id target;

@end


@implementation TGTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if(self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.pageCount = 1;
        self.pageCount = PAGECOUNT;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            self.sectionHeaderTopPadding = 0;
        }
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return self;
}


-(void)dealloc{
    self.delegate = nil;
    self.dataSource = nil;
}

#pragma mark - Setter
- (void)setDataList:(NSMutableArray *)dataList {
    _dataList = dataList;
    [self reloadData];
}

-(void)setDisableAutomaticDimension:(BOOL)disableAutomaticDimension{
    _disableAutomaticDimension = disableAutomaticDimension;
    if(disableAutomaticDimension){
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
}

#pragma mark - table view datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.isMuiltySection){
        return self.dataList.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isMuiltySection){//分组
        NSArray *sectionArr = [self.dataList objectAtIndex:section];
        return sectionArr.count;
    }else{
        return self.dataList.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(!self.reuseIdentifyBlock){
        NSAssert(NO, @"cellID can't be nil");
    }
    NSString *reuseId = self.reuseIdentifyBlock(indexPath);
    id model = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (self.isMuiltySection) {
        NSArray *sectionArr = [self.dataList objectAtIndex:indexPath.section];
        model = sectionArr[indexPath.row];
    }else {
        model = self.dataList[indexPath.row];
    }
    
    if (self.configCellBlock) {
        self.configCellBlock(indexPath, cell, model);
    }
    return  cell;
}


#pragma mark - table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id model = [self getModelAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.didSelectedBlock) {
        self.didSelectedBlock(indexPath,model,cell);
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = [self getModelAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.didDeselectedAtIndexPath) {
        self.didDeselectedAtIndexPath(indexPath,model,cell);
    }
}

#pragma mark tableView 滑动删除
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.sideDeleteBlock){
        return self.sideDeleteBlock(indexPath);
    }else{
        return nil;
    }
}

#pragma mark tableView 是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.sideDeleteBlock ? YES : NO;
}
#pragma mark tableView cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.heightForRowBlock) {
        return self.heightForRowBlock(indexPath);
    }else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark tableView cell 将要展示
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.willDisplayCell) {
        self.willDisplayCell(indexPath,cell);
    }
}

#pragma mark tableView HeaderView & FooterView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.configSectionHeaderViewBlock) return nil;
    if(!self.sectionHeaderViewReuseIdBlock){
        NSAssert(NO, @"section headerView reuserId can't be nil");
    }
    NSString *reuseId = self.sectionHeaderViewReuseIdBlock(section);
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    id sectionModel = [self getModelAtSection:section];
    if (self.configSectionHeaderViewBlock) {
        self.configSectionHeaderViewBlock(headerView,section,sectionModel);
    }
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.configSectionFooterViewBlock) return nil;
    if(!self.sectionFooterViewReuseIdBlock){
        NSAssert(NO, @"section FooterView reuserId can't be nil");
    }
    NSString *reuseId = self.sectionFooterViewReuseIdBlock(section);
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    id sectionModel = [self getModelAtSection:section];
    if (self.configSectionFooterViewBlock) {
        self.configSectionFooterViewBlock(footerView,section,sectionModel);
    }
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.sectionHeaderHeightBlock){
        return self.sectionHeaderHeightBlock(section);
    }else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.heightForFooterInSection){
        return self.heightForFooterInSection(section);
    }else{
        return 0.01;
    }
}

#pragma mark scrollView相关代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.scrollViewDidScroll){
        self.scrollViewDidScroll(scrollView);
    }
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(self.scrollViewDidZoom){
        self.scrollViewDidZoom(scrollView);
    }
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if(self.scrollViewDidScrollToTop){
        self.scrollViewDidScrollToTop(scrollView);
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.scrollViewWillBeginDragging){
        self.scrollViewWillBeginDragging(scrollView);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(self.scrollViewDidEndDragging){
        self.scrollViewDidEndDragging(scrollView,decelerate);
    }
}

#pragma mark - Private

-(id)getModelAtSection:(NSInteger)section {
    id model = nil;
    if (self.isMuiltySection) {
        model = [self.dataList objectAtIndex:section];
    }
    return model;
}

-(instancetype)getModelAtIndexPath:(NSIndexPath *)indexPath{
    id model = nil;
    if (self.isMuiltySection) {
        NSArray *sectionArr = [self.dataList objectAtIndex:indexPath.section];
        model = sectionArr[indexPath.row];
    }else {
        model = self.dataList[indexPath.row];
    }
    return model;
}

#pragma mark 暂无数据 & 网络错误相关
-(void)showNoMoreDataWithStates:(PlaceImgState)state errorDic:(NSDictionary *)errorDic backSel:(SEL)backSel{
    int errorCode = 0;
    if([errorDic.allKeys containsObject:NETERR_CODE]){
        errorCode = [errorDic[NETERR_CODE] intValue];
    }
    
    [self removeNoMoreData];
    UIView *noMoreDataView = [[UIView alloc]init];
    CGFloat noMoreDataViewW = NOMOREDATAVIEWW;
    CGFloat noMoreDataViewH = NOMOREDATAVIEWH;
    CGFloat noMoreDataViewX = (TGScreenW - noMoreDataViewW) / 2.0;
    CGFloat noMoreDataViewY = (self.frame.size.height - self.tableHeaderView.frame.size.height - noMoreDataViewH) / 2.0;
    noMoreDataView.frame = CGRectMake(noMoreDataViewX, noMoreDataViewY, noMoreDataViewW, noMoreDataViewH);
    UIImageView *subImgV = [[UIImageView alloc]init];
    subImgV.frame = CGRectMake(0, 0, noMoreDataViewW, noMoreDataViewH);
    if(state == PlaceImgStateNoMoreData){
        //显示暂无数据
        subImgV.image = [UIImage imageNamed:NOMOREDATAIMGNAME];
        self.mj_header.hidden = NO;
        self.scrollEnabled  = YES;
    }else if(state == PlaceImgStateNetErr){
        //显示网络错误普遍处理
        subImgV.image = [UIImage imageNamed:NETERRIMGNAME];
    }else{
        //显示网络根据特定情况处理
        if(!self.hideReloadBtn){
            subImgV.frame = CGRectMake(0, 0, noMoreDataViewW, noMoreDataViewH - RELOADBTNH - 2 * RELOADBTNMARGIN);
            
        }
        UIButton *reloadBtn = [[UIButton alloc]init];
        reloadBtn.clipsToBounds = YES;
        CGFloat reloadBtnW = RELOADBTNW;
        CGFloat reloadBtnH = self.hideReloadBtn ? 0 : RELOADBTNH;
        CGFloat reloadBtnX = (noMoreDataViewW - RELOADBTNW) / 2.0;
        CGFloat reloadBtnY = CGRectGetMaxY(subImgV.frame) + RELOADBTNMARGIN;
        reloadBtn.frame = CGRectMake(reloadBtnX, reloadBtnY, reloadBtnW, reloadBtnH);
        [reloadBtn setTitle:RELOADBTNTEXT forState:UIControlStateNormal];
        [reloadBtn setTitleColor: [UIColor tg_colorWithHexStr:RELOADBTNMAINCOLOR] forState:UIControlStateNormal];
        reloadBtn.titleLabel.font = [UIFont systemFontOfSize:RELOADBTNFONTSIZE];
        reloadBtn.clipsToBounds = YES;
        reloadBtn.layer.borderWidth = 1;
        reloadBtn.layer.borderColor = [UIColor tg_colorWithHexStr:RELOADBTNMAINCOLOR].CGColor;
        reloadBtn.layer.cornerRadius = 2;
        [reloadBtn addTarget:self.target action:backSel forControlEvents:UIControlEventTouchUpInside];
        //分开写 比较清晰
        switch (errorCode)
        {   //无网络连接
            case -1009:
            {
                //无网络连接
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_NO_NET];
                if(!self.hideMsgToast){
                    [self tg_makeToast:NETERRTOAST_NO_NET];
                }
                break;
            }
            case -1000:
            {
                //请求失败
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_REQ_ERROR];
                if(!self.hideMsgToast){
                    [self tg_makeToast:NETERRTOAST_REQ_ERROR];
                }
                break;
            }
            case -1001:
            {
                //请求超时
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_TIME_OUT];
                if(!self.hideMsgToast){
                    [self tg_makeToast:NETERRTOAST_TIME_OUT];
                }
                break;
            }
            case -1002:
            {
                //请求地址出错
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_ADDRESS_ERR];
                if(!self.hideMsgToast){
                    [self tg_makeToast:NETERRTOAST_ADDRESS_ERR];
                }
                break;
            }
                
            default:
            {
                //其他错误
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_OTHER_ERR];
                if(!self.hideMsgToast){
                    if([errorDic.allKeys containsObject:@"message"]){
                        [self tg_makeToast:[errorDic valueForKey:@"message"]];
                    }else{
                        [self tg_makeToast:NETERRTOAST_OTHER_ERR];
                    }
                }
                break;
            }
        }
        if(state == PlaceImgStateNetErrpecific){
            [noMoreDataView addSubview:reloadBtn];
        }
    }
    if(state != PlaceImgStateOnlyToast){
        subImgV.contentMode = UIViewContentModeScaleAspectFit;
        [noMoreDataView addSubview:subImgV];
    }
    [self addSubview:noMoreDataView];
    self.noMoreDataView = noMoreDataView;
}

-(void)removeNoMoreData{
    if(self.noMoreDataView){
        [self.noMoreDataView removeFromSuperview];
        self.noMoreDataView = nil;
    }
}
#pragma mark 重写reloadData
-(void)reloadData{
    [super reloadData];
    self.scrollEnabled = YES;
    if(!self.dataList.count){
        //没有数据
        NSDictionary *errDic = [NSDictionary dictionaryWithObjects:@[@0,@""] forKeys:@[NETERR_CODE,NETERR_MESSAGE]];
        [self showNoMoreDataWithStates:PlaceImgStateNoMoreData errorDic:errDic backSel:nil];
        self.mj_footer.hidden = YES;
    }else{
        [self removeNoMoreData];
        self.mj_footer.hidden = NO;
    }
}

#pragma mark - MJRefresh相关 若未使用MJRefresh 下方代码可以注释掉
-(void)setMJFooterStyle:(MJFooterStyle)style noMoreStr:(NSString *)noMoreStr{
    self.footerStyle = style;
    self.noMoreStr = noMoreStr;
}
-(void)addMJHeader:(headerBlock)block{
    __weak typeof(self) weakTable = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakTable) strongSelf = weakTable;
        strongSelf.isMJHeaderRef = YES;
        if(strongSelf.dataList.count % self.pageCount){//数据加载完毕
            strongSelf.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [strongSelf.dataList removeAllObjects];
        strongSelf.pageNo = 1;
        block();
    }];
}

-(void)addMJFooter:(footerBlock)block{
    [self addMJFooterStyle:MJFooterStylePlain noMoreStr:self.noMoreStr block:block];
}
-(void)addMJFooterStyle:(MJFooterStyle)style noMoreStr:(NSString *)noMoreStr block:(footerBlock)block{
    if(style == MJFooterStylePlain){
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.isMJHeaderRef = NO;
            self.pageNo++;
            block();
        }];
        MJRefreshBackNormalFooter *foot = (MJRefreshBackNormalFooter *)self.mj_footer;
        [foot setTitle:noMoreStr forState:MJRefreshStateNoMoreData];
    }else{
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.isMJHeaderRef = NO;
            self.pageNo++;
            block();
        }];
        if(self.noMoreStr.length){
            MJRefreshAutoNormalFooter *foot = (MJRefreshAutoNormalFooter *)self.mj_footer;
            [foot setTitle:noMoreStr forState:MJRefreshStateNoMoreData];
        }
    }
}
-(void)addPagingWithReqSel:(SEL _Nullable )sel target:(id)target{
    self.target = target;
    [self addMJHeader:^{
        if([target respondsToSelector:sel]){
            ((void (*)(id, SEL))[target methodForSelector:sel])(target, sel);
        }
    }];
    [self addMJFooter:^{
        if([target respondsToSelector:sel]){
            ((void (*)(id, SEL))[target methodForSelector:sel])(target, sel);
        }
    }];
}
-(void)updateTabViewStatus:(BOOL)status{
    [self updateTabViewStatus:status errDic:nil backSel:nil];
}

-(void)updateTabViewStatus:(BOOL)status errDic:(NSDictionary *)errDic backSel:(SEL)backSel{
    [self endMjRef];
    self.mj_header.hidden = NO;
    if(!status && !self.dataList.count){ //请求失败
        if(self.hideReloadBtn){
            self.mj_header.hidden = NO;
        }else{
            self.mj_header.hidden = YES;
        }
    }
    if(!self.dataList.count){
        self.scrollEnabled = !self.fixWhenNetErr;
    }else{
        self.scrollEnabled = YES;
    }
    if(status){//请求成功
        if(!self.dataList.count){//没有数据隐藏footer
            self.mj_footer.hidden = YES;
        }else{
            self.mj_footer.hidden = NO;
            if(self.dataList.count % self.pageCount){//数据全部加载完毕
                self.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }
    }else{//请求失败
        if(!self.dataList.count){
            self.mj_footer.hidden = YES;
            if(!errDic){
                [self showNoMoreDataWithStates:PlaceImgStateNetErr errorDic:errDic backSel:backSel];
            }else{
                [self showNoMoreDataWithStates:PlaceImgStateNetErrpecific errorDic:errDic backSel:backSel];
            }
        }else{
            [self showNoMoreDataWithStates:PlaceImgStateOnlyToast errorDic:errDic backSel:backSel];
        }
        if(self.pageNo > 1){
            self.pageNo--;
        }
    }
}
-(void)endMjRef{
    [self reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark setter

- (void)setCellReuseIdentifyList:(NSArray *)cellReuseIdentifyList {
    _cellReuseIdentifyList = cellReuseIdentifyList;
    for (NSString * identify in cellReuseIdentifyList) {
        [self registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
    }
}

- (void)setSectionHeaderReuseIdList:(NSArray *)sectionHeaderReuseIdList {
    _sectionHeaderReuseIdList = sectionHeaderReuseIdList;
    for (NSString * identify in sectionHeaderReuseIdList) {
        [self registerClass:NSClassFromString(identify) forHeaderFooterViewReuseIdentifier:identify];        
    }
}

@end

