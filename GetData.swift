//
//  GetData_new.swift
//  StarCard
//
//  Created by 雅风 on 16/9/3.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import Foundation

class GetData {
    
    
    var dictonary = ["aname":"","bphone":"","ctell":""]
    var arr = ["ss","dwdd"]
    
    var result_1 : NSDictionary = ["result" : "200"]
    var item:[Dictionary<String, String>] = []
    
    var name_arr : [String] = []
    
    var item_arr : [NSArray] = []
    var ok  = [[]]
    
    
    var array_StandingCommittee:[Dictionary<String, String>] = []
    
    func getData(_ Class_name:String) {
        
        
        var base = BaseClass()
        print("行了没")
        var url = URL(string:"http://xingkongus.duapp.com/index.php/User/loginAPP")
        
        var request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        
        // 设置请求体为二进制数据
        var bodyStr = NSString(format: "key=82015&name=\(Class_name)" as NSString)
        request.httpBody = bodyStr.data(using: String.Encoding.utf8.rawValue)
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response, data, connectionError) -> Void in
            
            print(response)
            print("可以没")
            
            
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
                    
                    return
                    
                }
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
            
            
            
        }
        
        
        
        
        
    }
    }
}
