# 文漫H5 iOS SDK使用说明

## 概述
网易文漫H5 iOS SDK可以帮助合作方iOS客户端快速接入网易文漫提供的功能丰富的H5应用，具体提供如下支持：
1. 提供了一个自定义的`ViewController`，可以**直接**或作为**子ViewController**展示
2. ViewController有默认的`返回按钮`、`关闭按钮`、`进度条`，可以实现快速`自定义视图`。
3. 通过简单的接口就可以实现H5**唤起**APP登录流程并**通知**H5获取账号信息功能
4. 内部处理了支付宝和微信支付的流程，可以实现H5调用`Native APP`支付，并在支付完成后**跳回原APP**；还可以自己通过代理处理其他支付方式
5. 支持添加客户端跟H5之间的**自定义**接口调用和回调，以支持合作方某些自定义的扩展需求
6. `用半天时间实现快速接入`

## 导入
依赖的**环境**
- iOS **8+**
- **AdSupport.framework** - 启用 Apple ADID 支持
- **CoreTelephony.framework** - 获取运营商
- **Security.framework** - 加密支持
- **CoreLocation.framework** - 获取定位信息的支持
- **SystemConfiguration.framework** - 获取联网方式(wifi, cellular)
- **libsqlite3.dylib** - sqlite 支持
- **libz.dylib** - gzip 压缩支持

**Pod**

```ruby
pod 'WMH5SDK', '~> 1.0.0'
```

SDK需要接入方提供的**参数**
- **loadUrl** - 接入H5的入口地址（如阅读地址[h5sdk.yuedu.163.com](https://h5sdk.yuedu.163.com)）
- **appChannel** - 合作方唯一标识
- **sdkAuth** - 登录的Token
- **callBackURLScheme** - 支付完成返回APP的Scheme

## 交互流程
我们的H5页面访问需要登录授权的资源时，需要**appChannel**和**sdkAuth**两个参数。**appChannel**在初始化SDK时需要指定，**sdkAuth**可以初始化时指定、未登录时需要实现获取sdkAuth代理方法。具体流程如下：
- 用户**已登录**
![已登录时序图](https://upload-images.jianshu.io/upload_images/1776603-0cfebe04a9f050a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 用户**未登录**
![未登录时序图](https://upload-images.jianshu.io/upload_images/1776603-01439065ca147bda.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 接口说明
### 初始化
- **初始化**控制器

```objective-c
/**
 @param url H5入口
 @param appChannel 合作方唯一标识
 @param adkAuth 登录Token 可以不指定
 @param scheme 当前App URL Scheme
 */
WMH5ViewController *h5Controller = [WMH5ViewController h5ControllerWithUrl:url appChannel:appChannel sdkAuth:sdkAuth callBackURLScheme:scheme];
```

- **设置**代理

```objective-c
h5Controller.delegate = self;
```

- **展示**页面

```objective-c
[self.navigationController pushViewController:h5Controller animated:YES];
```

- 代理需要实现`获取SDKAuth`、`退出sdk页面`的方法

```objective-c
/**
 获取sdkAuth

 @param h5Controller 控制器实例
 @param appChannel 合作方唯一标识
 @param completeHandler 获取完成回调
 */
- (void)h5Controller:(WMH5ViewController *)h5Controller fetchSDKAuthForAppChannel:(NSString *)appChannel completeHandler:(void (^)(NSString * _Nonnull))completeHandler {
  //实现获取sdkAuth逻辑
  ///先调用APP登录逻辑
  ///然后向服务器索取sdkAuth
  ///服务器返回之后，通知sdk获取sdkAuth
  completeHandler(sdkAuth);
}

/**
 退出H5页面

 @param h5Controller H5控制器实例
 */
- (void)quitH5Controller:(WMH5ViewController *)h5Controller {
  //退出h5Controller
  [self.navigationController popViewControllerAnimated:YES];
}
```

###  **自定义**行为
- `Native`与`H5`交互

```objective-c
/**
 Native注册JS调用的方法
 
 @param handlerName Native方法名
 @param handler Native方法体
 */
[h5Controller registerHandler:@"methodNameForJS" handler:^(id  _Nonnull data, WMH5ResponseCallback  _Nonnull responseCallback) {
  //data JS传递的参数
  //responseCallback，回调JS
}];

/**
 调用JS方法
 
 @param handlerName JS方法名
 @param data 参数
 @param responseCallback Native回调
 */
[h5Controller callHandler:@"JSMethodName" data:forJSData responseCallback:^(id  _Nullable responseData) {
  //JS调用之后的处理逻辑
}];
```

- `改变`WebView行为

```objective-c
[h5Controller setWebViewDelegate:webViewDelegeta];
```

- 关于`进度条`

```objective-c
/*显示-隐藏*/
h5Controller.pregressViewHidden = NO;
/*进度条颜色*/
h5Controller.progressViewColor = [UIColor yellowColor];
```

- 关于`Navigation`
可以自定义返回按钮(`backItem`)、关闭按钮(`closeItem`)，并提供了返回(`goBack`)、关闭(`closeH5`)方法。
- 关于`界面`
可以自定义界面位置大小，将sdk提供的`ViewController`作为`子控制器`布局，必须将`isCustomUI`先置YES。

```objective-c
/*必须要设置*/
h5Controller.isCustomUI = YES;
```

## 支付相关
### 配置`Info.Plist`
- 增加微信与支付宝的Scheme
1. `Info.Plist`中找到`LSApplicationQueriesSchemes`项
2. 增加`weixin`
3. 增加`alipay`
![Info.Plist](https://upload-images.jianshu.io/upload_images/1776603-971df71b0c7ce064.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 支付完成，回跳APP的`Scheme`
- `Scheme`需要经过[微信后台](https://pay.weixin.qq.com/index.php/core/home/login?return_url=%2F)注册验证，`Scheme`生成过程
1. H5应用服务提供方需要在微信支付后台为应用注册**域名**，如**阅读测试服务**提供的域名是**th5sdk.yuedu.163.com**
2. 由该域名生成`子域名`，如**demoa.th5sdk.yuedu.163.com**
3. 接入方需要在**自己的APP**中以上面的`子域名`注册`URL Scheme`
4. 设置SDK的`callBackURLScheme`为上面注册的`Scheme`
![Alt text](https://upload-images.jianshu.io/upload_images/1776603-76c51d74f21a718d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 自定义支付行为
- 可以**劫持**需要加载的`URL`，自定义支付行为
1. 设置WebView的代理
2. 实现`webView:shouldStartLoadWithRequest:navigationType:`方法
3. `劫持`支付请求的URL，实现自己的逻辑

## 体量
- 集成WMH5SDk后，app会增加`0.6M`