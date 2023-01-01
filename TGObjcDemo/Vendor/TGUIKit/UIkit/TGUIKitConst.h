//
//  TGUIKitConst.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/3.
//

#ifndef TGUIKitConst_h
#define TGUIKitConst_h

///分页数量
static NSUInteger const PAGECOUNT = 10;
///暂无更多View宽度
static CGFloat const NOMOREDATAVIEWW = 150.0;
///暂无更多View高度
static CGFloat const NOMOREDATAVIEWH = 150.0;
///重新加载按钮宽度
static CGFloat const RELOADBTNW = 80.0;
///重新加载按钮高度
static CGFloat const RELOADBTNH = 25.0;
///重新加载按钮文字
static NSString *const RELOADBTNTEXT = @"重新加载";
///重新加载按钮主题色
static NSString *const RELOADBTNMAINCOLOR = @"0xe8412e";
///重新加载按钮上下间距
static int const RELOADBTNMARGIN = 10.0;
///重新加载按钮字体大小
static CGFloat const RELOADBTNFONTSIZE = 13.0;

///暂无更多数据图片
static NSString *const NOMOREDATAIMGNAME = @"nomoreDataImg";
///网络错误普遍处理图片
static NSString *const NETERRIMGNAME = @"netErrImg";

///网络错误特定处理图片与提示内容
///无网络连接
static NSString *const NETERRIMGNAME_NO_NET = @"noNetErrImg";
static NSString *const NETERRTOAST_NO_NET = @"无网络连接";
///请求失败
static NSString *const NETERRIMGNAME_REQ_ERROR = @"noNetErrImg";
static NSString *const NETERRTOAST_REQ_ERROR = @"请求失败";
///请求超时
static NSString *const NETERRIMGNAME_TIME_OUT = @"noNetErrImg";
static NSString *const NETERRTOAST_TIME_OUT = @"请求超时";
///请求地址出错
static NSString *const NETERRIMGNAME_ADDRESS_ERR = @"noNetErrImg";
static NSString *const NETERRTOAST_ADDRESS_ERR = @"请求地址出错";
///其他错误
static NSString *const NETERRIMGNAME_OTHER_ERR = @"";
static NSString *const NETERRTOAST_OTHER_ERR = @"未知错误";

///获取错误code的key
static NSString *const NETERR_CODE = @"code";
///获取错误message的key
static NSString *const NETERR_MESSAGE = @"message";

#endif /* TGUIKitConst_h */
