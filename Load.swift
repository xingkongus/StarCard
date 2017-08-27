//
//  Load_new.swift
//  StarCard
//
//  Created by 雅风 on 16/9/3.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import Foundation


class Load: UIViewController {
    var str_error = ""
    var arr_1 : [String]!
    
    var arr_team : [String]!
    
    var Root : [NSDictionary]! = []
    var dictonary = ["aname":"","bphone":"","ctell":""]
    var arr = ["ss","dwdd"]
    
    var result_1 : NSDictionary = ["result" : "200"]
    var item:[Dictionary<String, String>] = []
    
    var name_arr : [String] = []
    
    var item_arr : [NSArray] = []
    var ok  = [[]]
    
    
    var array_StandingCommittee:[Dictionary<String, String>] = []
    
    
    


    
    override func viewDidLoad() {
        var base = BaseClass()
        // 创建目标队列
        let workingQueue = DispatchQueue(label: "my_queue", attributes: [])
        
        // 派发到刚创建的队列中，GCD 会负责进行线程调度
        workingQueue.async {
            
            // 在 workingQueue 中异步进行
            print("努力工作")
            var base : BaseClass = BaseClass()
            
            var login : String = String()
            
            login = base.cacheGetString("login")
            
            print("传值",login)
            
//            let getdata = GetData()
//            
//            getdata.getData(login)
            print("行了没")
            var url = URL(string:"http://xingkongus.duapp.com/index.php/User/loginAPP")
            
            var request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
            request.httpMethod = "POST"
            
            // 设置请求体为二进制数据
            var bodyStr = NSString(format: "key=82015&name=\(login)" as NSString)
            request.httpBody = bodyStr.data(using: String.Encoding.utf8.rawValue)
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response, data, connectionError) -> Void in
                
                print(response)
                print("可以没")
                self.str_error = NSString(data:data!,encoding:String.Encoding.utf8.rawValue) as! String
                print("怎样",self.str_error)
                
                
                if connectionError != nil {
                    
                    print("login error....\(connectionError)")
                    
                    
                    
                } else {
                    print("可以没1")
                    var a = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    print(self.result_1)
                    print("可以啦",a)
                    
                    var dict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("POST: -> \(dict)")
                    if dict["result"] as! Int == 200{
                        print("成功了！")
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "系统提示",
                                                                    message: "请检查您的ID输入是否正确或网络连接是否正常", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "好的", style: .default,
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
                                                            let myStoryBoard = self.storyboard
                                                            
                                                            let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "get"))! as UIViewController
                                                            self.present(anotherView, animated: true, completion: nil)
                                                            
                            })
                            
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        
                        }
                    
                        
                    }
                    if dict["result"] as! Int != 200{
                    var weatherInfo : AnyObject = dict.object(forKey: "departments")! as AnyObject//json结构字段名。
                    
                    //首先判断能不能转换
                    if (!JSONSerialization.isValidJSONObject(weatherInfo)) {
                        print("is not a valid json object")
                        return
                    }
                    //利用OC的json库转换成OC的NSData，
                    //如果设置options为NSJSONWritingOptions.PrettyPrinted，则打印格式更好阅读
                    let data : Data! = try? JSONSerialization.data(withJSONObject: weatherInfo, options: [])
                    //NSData转换成NSString打印输出
                    let str = NSString(data:data, encoding: String.Encoding.utf8.rawValue)!
                    //输出json字符串
                    //print("Json Str:"); print(str)
                    
                    
                    
                    //把NSData对象转换回JSON对象
                    let json : AnyObject = try! JSONSerialization
                        .jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                    
                    let jsonArray = json as! NSArray
                    
                    print("Json Object:");
                    print(json)
                    
                    print(json.count)
                    for i in 0..<json.count {
                        //print(json[i])
                        let name = (jsonArray[i] as AnyObject).object(forKey: "name")!
                        
                        self.name_arr.append(name as! String)
                        
                        let member  = (jsonArray[i] as AnyObject).object(forKey: "members")!
                        
                        let member_1 = member as! NSArray
                        print(name)
                        
                        print(member)
                        
                        for j in 0..<member_1.count{
                            let uname = (member_1[j] as AnyObject).object(forKey: "username")! as! String
                            let phone = (member_1[j] as AnyObject).object(forKey: "phone") as! String
                            let tell = (member_1[j] as AnyObject).object(forKey: "tel") as! String
                            
                            
                            self.dictonary["aname"] = uname
                            
                            self.dictonary["bphone"] = phone
                            
                            self.dictonary["ctell"] = tell
                            
                            //将数据添加进数组
                            
                            self.item.append(self.dictonary)
                            
                            
                            
                            
                            
                            
                            
                            
                            print(uname)
                            print(phone)
                            print(tell)
                        }
                        
                        
                        
                        self.item_arr.append(self.item as NSArray)
                        
                        print("输出",self.item_arr[i])
                        
                        self.item.removeAll()
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    for k in 0..<json.count{
                        
                        
                        
                        
                        var Data_array:Data = NSKeyedArchiver.archivedData(withRootObject: self.item_arr[k])
                        
                        print("测试",self.item_arr[k])
                        
                        //print("ok值",self.ok)
                        
                        print(self.name_arr[k])
                        
                        base.cacheSetArray(self.name_arr[k], value: Data_array as AnyObject)
                        
                        
                    }
                    
                    
                    
                    //            self.ok.removeAll()
                    //            
                    //            self.item.removeAll()
                    
                    //            self.item_arr.removeAll()
                    
                    
                    DispatchQueue.main.async {
                        // 返回到主线程更新 UI
                        print("结束工作，更新 UI")
                        
                        
                        for i in 0..<self.name_arr.count{
                            
                            print("哈哈哈啊哈哈",self.name_arr.count)
                            
                            var arr_name = base.cacheGetArray(self.name_arr[i])
                            
                            var myName:AnyObject? = NSKeyedUnarchiver.unarchiveObject(with: arr_name as! Data) as AnyObject?
                            
                            var Name = myName as! [Dictionary<String, String>]
                            
                            //var array :[Dictionary<String, String>]!
                            
                            //array.append(Name)
                            
                            
                            
                            var quotation = ["Playname" : self.name_arr[i],"quotations" : Name ] as [String : Any]
                            
                            print("测测测测二测测测测测测测而出",quotation)
                            self.Root.append(quotation as NSDictionary)
                            
                        }
                        
                        
                        print("最终",self.Root)
                        
                        
                        var Data_array:Data = NSKeyedArchiver.archivedData(withRootObject: self.Root)
                        
                        base.cacheSetArray("Root", value: Data_array as AnyObject)
                        base.cacheSetString("n", value: "1")
                        let myStoryBoard = self.storyboard
                        
                        let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "post"))! as UIViewController
                        self.present(anotherView, animated: true, completion: nil)
                        
                        
                        
                    }
   
                }
                
                }
                
                
                
            }

//            Thread.sleep(forTimeInterval: 1)  // 模拟两秒的执行时间
//            
//            DispatchQueue.main.async {
//                // 返回到主线程更新 UI
//                print("结束工作，更新 UI")
//                
//                
//                
//                for i in 0..<self.name_arr.count{
//                    
//                    print("哈哈哈啊哈哈",self.name_arr.count)
//                    
//                    var arr_name = base.cacheGetArray(self.name_arr[i])
//                    
//                    var myName:AnyObject? = NSKeyedUnarchiver.unarchiveObject(with: arr_name as! Data) as AnyObject?
//                    
//                    var Name = myName as! [Dictionary<String, String>]
//                    
//                    //var array :[Dictionary<String, String>]!
//                    
//                    //array.append(Name)
//                    
//                    
//                    
//                    var quotation = ["Playname" : self.name_arr[i],"quotations" : Name ] as [String : Any]
//                    
//                    print("测测测测二测测测测测测测而出",quotation)
//                    self.Root.append(quotation as NSDictionary)
//               
//                }
//                
//                
//                print("最终",self.Root)
//                
//                
//                var Data_array:Data = NSKeyedArchiver.archivedData(withRootObject: self.Root)
//                
//                base.cacheSetArray("Root", value: Data_array as AnyObject)
//             
//                let myStoryBoard = self.storyboard
//                
//                let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "post"))! as UIViewController
//                self.present(anotherView, animated: true, completion: nil)
//                
//                
//                
//            }
            
        
        }
        
    }
    
    
}


