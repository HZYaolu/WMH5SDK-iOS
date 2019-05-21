//
//  WMH5ViewController.h
//  SnailReader
//
//  Created by F_knight on 2018/6/29.
//  Copyright © 2018年 com.netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 回调 Callback
 
 @param responseData 回调数据
 */
typedef void (^WMH5ResponseCallback)(__nullable id responseData);

/**
 Javascript调用native的Handler
 
 @param data Javascript传过来的数据
 @param responseCallback native回调Javascript Callback
 */
typedef void (^WMH5Handler)(id data, WMH5ResponseCallback responseCallback);

@class WMH5ViewController;

@protocol WMH5ViewControllerDelegate <NSObject>

@optional
/**
 H5页面登录成功后，返回auth的窗口

 @param h5Controller H5控制器实例
 @param auth 通行凭证
 */
- (void)h5Controller:(WMH5ViewController *)h5Controller authForLoginSuccess:(NSString *)auth;

@required

/**
 获取sdkAuth

 @param h5Controller H5控制器实例
 @param appChannel 合作方唯一标识
 @param completeHandler 获取完成回调
 */
- (void)h5Controller:(WMH5ViewController *)h5Controller fetchSDKAuthForAppChannel:(NSString *)appChannel completeHandler:(void(^)(NSString *sdkAuth))completeHandler;

/**
 退出H5页面

 @param h5Controller H5控制器实例
 */
- (void)quitH5Controller:(WMH5ViewController *)h5Controller;

@end;


@interface WMH5ViewController : UIViewController

@property (nonatomic, weak, nullable) id<WMH5ViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) UIWebView *webView;

/**
 类初始化方法

 @param url H5入口
 @param appChannel 合作方唯一标识
 @param sdkAuth 登录Token 没有可以不指定
 @param scheme 当前App URL Scheme
 @return H5的控制器实例
 */
+ (instancetype)h5ControllerWithUrl:(NSString *)url
                         appChannel:(NSString *)appChannel
                            sdkAuth:(NSString * __nullable)sdkAuth
                  callBackURLScheme:(NSString * __nullable)scheme;

/**
 指定初始化方法

 @param url H5入口
 @param appChannel 合作方唯一标识
 @param sdkAuth 登录Token 没有可以不指定
 @param scheme 当前App URL Scheme
 @return H5的控制器实例
 */
- (instancetype)initWithUrl:(NSString *)url
                 appChannel:(NSString *)appChannel
                    sdkAuth:(NSString * __nullable)sdkAuth
          callBackURLScheme:(NSString * __nullable)scheme;

/**
 Native注册JS调用的方法
 
 @param handlerName Native方法名
 @param handler Native方法处理
 */
- (void)registerHandler:(NSString *)handlerName
                handler:(WMH5Handler)handler;

/**
 调用JS方法
 
 @param handlerName JS方法名
 @param data JS方法参数
 @param responseCallback JS回调
 */
- (void)callHandler:(NSString *)handlerName
               data:(id __nullable)data
   responseCallback:(WMH5ResponseCallback __nullable)responseCallback;

/**
 设置webview Delegate
 
 @param webViewDelegate webviewDelegate
 */
- (void)setWebViewDelegate:(id<UIWebViewDelegate>)webViewDelegate;

@end


@interface WMH5ViewController (NavigationAction)

@property (nonatomic, strong) UIBarButtonItem *backItem;

@property (nonatomic, strong) UIBarButtonItem *closeItem;

/**
 回退，有历史记录回退上一页
 没有则关闭H5 Controller
 */
- (void)goBack;

/**
 关闭H5页面
 */
- (void)closeH5;

@end

@interface WMH5ViewController (CustomUI)

/*Controller作为子控制器，自定义视图大小位置，isCustomUI=YES*/
@property (nonatomic, assign) BOOL isCustomUI;

/*进度条颜色*/
@property (nonatomic, strong) UIColor *progressViewColor;
/*隐藏进度条*/
@property (nonatomic, assign) BOOL progressViewHidden;

@end

NS_ASSUME_NONNULL_END
