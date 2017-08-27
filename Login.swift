//
//  File.swift
//  StarCard
//
//  Created by 雅风 on 16/7/24.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import UIKit


class Login: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    
    var tf = "haha"
    let reachability = Reachability()!
    
    func NetworkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.isReachable { // 判断网络连接状态
            print("网络连接：可用")
            DispatchQueue.main.async {
            let myStoryBoard = self.storyboard
            var base = BaseClass()
            
            self.tf = self.textfield.text!
            print("没传",self.tf)
            
            
            
            base.cacheSetString("login", value: self.tf)
            let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "load"))! as UIViewController
            self.present(anotherView, animated: true, completion: nil)
            
            }
            
            
            if reachability.isReachableViaWiFi { // 判断网络连接类型
                print("连接类型：WiFi")
                // strServerInternetAddrss = getHostAddress_WLAN() // 获取主机IP地址 192.168.31.2 小米路由器
                // processClientSocket(strServerInternetAddrss)    // 初始化Socket并连接，还得恢复按钮可用
            } else {
                print("连接类型：移动网络")
                // getHostAddrss_GPRS()  // 通过外网获取主机IP地址，并且初始化Socket并建立连接
            }
        } else {
            print("网络连接：不可用")
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "请打开网络连接", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "确定", style: .default,
                                             handler: {
                                                action in
                                                print("点击了确定")
                                                var base = BaseClass()
                                                let userDefault:UserDefaults = UserDefaults.standard
                                                let ar:NSDictionary = userDefault.dictionaryRepresentation() as NSDictionary
                                                
                                                for key in ar.allKeys {
                                                    
                                                    //            userDefault.removeObjectForKey(key as String)
                                                    
                                                    //2015年5月2号修改
                                                    userDefault.removeObject(forKey: key as! String)
                                                    
                                                    userDefault.synchronize()
                                                    
                                                    
                                                }
//                                                let myStoryBoard = self.storyboard
//                                                
//                                                let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "get"))! as UIViewController
//                                                self.present(anotherView, animated: true, completion: nil)
                                                
                      return
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil) // 警告框，提示没有网络
            }
        }
    }
   
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var tef: UITextField!
    
    @IBOutlet weak var bt_1: UIButton!
    
    
    @IBAction func bt_login(_ sender: AnyObject) {
        NetworkStatusListener()
            }
    //通过委托来实现放弃第一响应者
    //UITextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = 0
        })
        textfield.resignFirstResponder()
        return true
    }
    
    
    
    //通过委托来实现放弃第一响应者
    //UITextView Delegate  Method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            
            textfield.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    override func viewDidLoad() {
//        Thread.sleep(forTimeInterval: 0.5) //延长0.5秒
        launchAnimation()
        var base = BaseClass()
        base.cacheSetString("n", value: "0")
        
        
        print("开始1")
        //设置圆角
        bt_1.backgroundColor = UIColor(red:0.02, green:0.48, blue:1, alpha:1)
        bt_1.layer.cornerRadius = 10
        bt_1.setTitle("登录", for: UIControlState())//设置按钮标题
        bt_1.setTitleColor(UIColor.white, for: UIControlState())//设置按钮标题颜色
        
        //注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(Login.handleTap(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(Login.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        
        if sender.state == .ended {
            print("收回键盘")
            UIView.animate(withDuration: 0.4, animations: {
                self.view.frame.origin.y = 0
            })
            textfield.resignFirstResponder()
            
        }
        sender.cancelsTouchesInView = false
    }
    
    func keyboardWillShow(_ notification:Notification){if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
              textf(textfield)
        }
    }
    func textf(_ textView: UITextField) {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.frame.origin.y = -220
        })
        
    }
    //播放启动画面动画
    private func launchAnimation() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let img = "launchScreen_2"
        
            //获取启动图片
            let launchImage = UIImage(named: img)
            let launchview = UIImageView(frame: UIScreen.main.bounds)
            launchview.image = launchImage
            //将图片添加到视图上（分两种情况）
            //情况1:没有导航栏
            self.view.addSubview(launchview)
            //情况2:有导航栏
//            let delegate = UIApplication.shared.delegate
//            let mainWindow = delegate?.window
//            mainWindow!!.addSubview(launchview)
            
            //播放动画效果，完毕后将其移除
            UIView.animate(withDuration: 1, delay: 1.5, options: .beginFromCurrentState,
                           animations: {
                            launchview.alpha = 0.0
                            launchview.layer.transform = CATransform3DScale(
                                CATransform3DIdentity, 1.5, 1.5, 1.0)
            }) { (finished) in
                launchview.removeFromSuperview()
            }
        
    }
    
    

    
    
    override func viewDidAppear(_ animated: Bool) {
        let userlogin = UserDefaults.standard.string(forKey: "login")
        print("开始")
        if (userlogin != nil) {
            print("可以")
            let myStoryBoard = self.storyboard
            let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "post"))! as UIViewController
            self.present(anotherView, animated: true, completion: nil)
            }

    }
    
        
    
        
    
    
    override func viewWillAppear(_ animated: Bool) {
//        var base = BaseClass()
//       var n = base.cacheGetString("n")
//        if n == "1" {
//            let myStoryBoard = self.storyboard
//            let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "post"))! as UIViewController
//            self.present(anotherView, animated: true, completion: nil)
//
//        }
        

        
        
}

        
        
        

        
        
        
                
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
                

            
            
            
            
            
        
    }
    

