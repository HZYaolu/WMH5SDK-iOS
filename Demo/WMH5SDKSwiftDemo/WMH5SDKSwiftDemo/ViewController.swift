//
//  ViewController.swift
//  WMH5SDKSwiftDemo
//
//  Created by yebw on 2018/7/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = (section==0 ? "阅读" : "漫画")
        return title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellId")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellId")
        }
        
        var text = ""
        
        if indexPath.row == 0 {
            text = "测试服务器-已登录"
        } else if indexPath.row == 1 {
            text = "测试服务器-未登录"
        } else if indexPath.row == 2 {
            text = "线上服务器-未登录"
        }
        
        cell?.textLabel?.text = text
        
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        var url = ""
        var channel = ""
        var sdkAuth: String? = nil
        var callbackUrl: String? = nil
        
        if indexPath.section == 0 {
            channel = "123"
            callbackUrl = "swiftdemo.th5sdk.yuedu.163.com"

            if indexPath.row == 0 {
                url = "https://th5sdk.yuedu.163.com"
                sdkAuth = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJ3YnRlc3QxIiwibmlja25hbWUiOiJ3YiIsIm1vYmlsZSI6IiIsImFwcEtleSI6IjEyMyIsImF2YXRhciI6IiIsImV4dGVuZEluZm8iOiIiLCJpYXQiOjE1MzAxNTE1OTZ9.GErv67VXPgUhEfVQVfVpLGnE-fWVQTOGLxy0EDXNmwI"
            } else if indexPath.row == 1 {
                url = "https://th5sdk.yuedu.163.com"
            } else if indexPath.row == 2 {
                url = "https://h5sdk.yuedu.163.com"
            }
        } else {
            channel = "gtest"
            callbackUrl = "swiftdemo.th5sdk.manhua.163.com"
            
            if indexPath.row == 0 {
                url = "https://th5sdk.manhua.163.com"
                sdkAuth = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJ1c2VyaWQkNyIsIm5pY2tuYW1lIjoi5rWL6K-V55So5oi3NyIsIm1vYmlsZSI6IjExMjIzMzQ0IiwiYXBwS2V5IjoiNGkzd3N4ZHoiLCJvaWQiOiIiLCJhdmF0YXIiOiJodHRwczovL2Vhc3lyZWFkLm5vc2RuLjEyNy5uZXQvcGljLzIwMTYvMDgvMDEvY2FiNzhkOTVhYjhhNGY2NDhlZTZkMWQyNmJlZmMxOWIucG5nIiwiaWF0IjoxNTMxMjc1NTkyfQ.zeNx6rmHCtxAe-WZ1rnqLszzEmwuAT1HoUe3r8AG3HI"
            } else if indexPath.row == 1 {
                url = "https://th5sdk.manhua.163.com"
            } else if indexPath.row == 2 {
                url = "https://h5sdk.manhua.163.com"
            }
        }

        let vc = WMH5ViewController(url: url, appChannel: channel, sdkAuth: sdkAuth, callBackURLScheme: callbackUrl)
        vc.delegate = self
        if navigationController == nil {
            let nc = UINavigationController(rootViewController: vc)
            present(nc, animated: true, completion: nil)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: WMH5ViewControllerDelegate {
    func h5Controller(_ h5Controller: WMH5ViewController, fetchSDKAuthForAppChannel appChannel: String, completeHandler: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            if appChannel == "123" {
                let sdkAuth = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJ3YnRlc3QxIiwibmlja25hbWUiOiJ3YiIsIm1vYmlsZSI6IiIsImFwcEtleSI6IjEyMyIsImF2YXRhciI6IiIsImV4dGVuZEluZm8iOiIiLCJpYXQiOjE1MzAxNTE1OTZ9.GErv67VXPgUhEfVQVfVpLGnE-fWVQTOGLxy0EDXNmwI"
                
                completeHandler(sdkAuth)
            } else if appChannel == "gtest" {
                let sdkAuth = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJ1c2VyaWQkNyIsIm5pY2tuYW1lIjoi5rWL6K-V55So5oi3NyIsIm1vYmlsZSI6IjExMjIzMzQ0IiwiYXBwS2V5IjoiNGkzd3N4ZHoiLCJvaWQiOiIiLCJhdmF0YXIiOiJodHRwczovL2Vhc3lyZWFkLm5vc2RuLjEyNy5uZXQvcGljLzIwMTYvMDgvMDEvY2FiNzhkOTVhYjhhNGY2NDhlZTZkMWQyNmJlZmMxOWIucG5nIiwiaWF0IjoxNTMxMjc1NTkyfQ.zeNx6rmHCtxAe-WZ1rnqLszzEmwuAT1HoUe3r8AG3HI"
                
                completeHandler(sdkAuth)
            }
        }
    }
    
    func quitH5Controller(_ h5Controller: WMH5ViewController) {
        guard let nc = self.navigationController else {
            dismiss(animated: true, completion: nil)
            
            return
        }
        
        if nc.viewControllers.count > 0 {
            nc.popViewController(animated: true)
        } else {
            nc.dismiss(animated: true, completion: nil)
        }
    }
}




