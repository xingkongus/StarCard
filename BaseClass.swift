//
//  BaseClass.swift
//  StarCard
//
//  Created by 雅风 on 16/7/23.
//  Copyright © 2016年 星夜暮晨. All rights reserved.
//

import Foundation

open class BaseClass {
    func cacheSetString(_ key:String,value:String)  {
        let userInfo = UserDefaults()
        
        userInfo.setValue(value, forKey: key)
        
    }
    
    
    
    func cacheGetString(_ key:String) -> String {
        let userInfo = UserDefaults()
        let tmpSign = userInfo.string(forKey: key)
        return tmpSign!
        
        
    }
    
    
    func cacheSetArray(_ key:String,value:AnyObject) {
        let userInfo = UserDefaults()
        
        userInfo.setValue(value, forKey: key)
        
    }
    
    func cacheGetArray(_ key:String) -> AnyObject {
        let userInfo = UserDefaults()
        
        let tmSign = userInfo.object(forKey: key)
        
        return tmSign! as AnyObject
        
        
    }
    
}
