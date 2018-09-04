//
//  TableViewController.m
//  WMH5SDKDemo
//
//  Created by F_knight on 2018/7/4.
//  Copyright © 2018年 F_knight. All rights reserved.
//

#import "TableViewController.h"
#import <WMH5SDK/WMH5ViewController.h>

@interface TableViewController () <WMH5ViewControllerDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *formalUrl;
@property (nonatomic, copy) NSString *appChannel;
@property (nonatomic, copy) NSString *sdkAuth;
@property (nonatomic, copy) NSString *urlScheme;

@property (nonatomic, copy) NSString *mhUrl;
@property (nonatomic, copy) NSString *mhAppChannel;
@property (nonatomic, copy) NSString *mhSdkAuth;
@property (nonatomic, copy) NSString *mhUrlSchemem;

@property (nonatomic, copy) NSString *currentSdkAuth;

@property (nonatomic, strong) NSArray<NSArray *> *dataSource;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //阅读
    self.url = @"https://th5sdk.yuedu.163.com";
    self.formalUrl = @"https://h5sdk.yuedu.163.com";
    self.appChannel = @"123";
    self.sdkAuth = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJ3YnRlc3QxIiwibmlja25hbWUiOiJ3YiIsIm1vYmlsZSI6IiIsImFwcEtleSI6IjEyMyIsImF2YXRhciI6IiIsImV4dGVuZEluZm8iOiIiLCJpYXQiOjE1MzAxNTE1OTZ9.GErv67VXPgUhEfVQVfVpLGnE-fWVQTOGLxy0EDXNmwI";
    self.urlScheme = @"demoa.th5sdk.yuedu.163.com";
    //漫画
    self.mhUrl = @"https://th5sdk.manhua.163.com/";
    self.mhAppChannel = @"gtest";
    self.mhSdkAuth = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJ1c2VyaWQkNyIsIm5pY2tuYW1lIjoi5rWL6K-V55So5oi3NyIsIm1vYmlsZSI6IjExMjIzMzQ0IiwiYXBwS2V5IjoiNGkzd3N4ZHoiLCJvaWQiOiIiLCJhdmF0YXIiOiJodHRwczovL2Vhc3lyZWFkLm5vc2RuLjEyNy5uZXQvcGljLzIwMTYvMDgvMDEvY2FiNzhkOTVhYjhhNGY2NDhlZTZkMWQyNmJlZmMxOWIucG5nIiwiaWF0IjoxNTMxMjc1NTkyfQ.zeNx6rmHCtxAe-WZ1rnqLszzEmwuAT1HoUe3r8AG3HI";
    self.mhUrlSchemem = @"demoa.testpay.manhua.163.com";
    
    
    
    self.dataSource = @[@[@"测试服务器—登录", @"测试服务器—未登录", @"正式服务器—未登录"], @[@"测试服务器—登录", @"测试服务器—未登录"]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewIdentifier"];
    }
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"阅读";
    }
    else {
        return @"漫画";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *url, *appChannel, *callBackURLScheme, *currentSdkAuth;
    if (indexPath.section == 0) {
        url = self.url;
        appChannel = self.appChannel;
        callBackURLScheme = self.urlScheme;
        currentSdkAuth = self.sdkAuth;
        self.currentSdkAuth = self.sdkAuth;
       if (indexPath.row == 1) {
            //未登录
            currentSdkAuth = nil;
        }
        else if (indexPath.row == 2) {
            //正式地址
            url = self.formalUrl;
            currentSdkAuth = nil;
            self.currentSdkAuth = nil; //正式环境需要自己赋值
        }
    }
    else {
        url = self.mhUrl;
        appChannel = self.mhAppChannel;
        callBackURLScheme = self.mhUrlSchemem;
        currentSdkAuth = self.mhSdkAuth;
        self.currentSdkAuth = self.mhSdkAuth;
        if (indexPath.row == 1) {
            //未登录
            currentSdkAuth = nil;
        }
    }
    WMH5ViewController *h5Controller = [WMH5ViewController h5ControllerWithUrl:url appChannel:appChannel sdkAuth:currentSdkAuth callBackURLScheme:callBackURLScheme];
    h5Controller.delegate = self;
    [self.navigationController pushViewController:h5Controller animated:YES];
}

#pragma mark - WMH5ViewControllerDelegate
//获取SDKAuth方法
- (void)h5Controller:(WMH5ViewController *)h5Controller fetchSDKAuthForAppChannel:(NSString *)appChannel completeHandler:(void (^)(NSString * _Nonnull))completeHandler {
    //处理登录逻辑
    //登录完成后向服务器获取sdkAuth
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录提示" message:@"是否需要登录账号？！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *OKaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //通知sdk 已完成sdkAuth获取
        completeHandler(self.currentSdkAuth);
    }];
    [alertController addAction:action];
    [alertController addAction:OKaction];
    [h5Controller presentViewController:alertController animated:YES completion:^{
        
    }];
}

//退出sdk方法
- (void)quitH5Controller:(WMH5ViewController *)h5Controller {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
