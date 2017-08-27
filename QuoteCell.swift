//
//  QuoteCell.swift
//  StarCard
//
//  Created by Semper Idem on 14-10-22.
//  Copyright (c) 2014年 星夜暮晨. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
    
    var quotation: Quotation!
    
    var filtered:String = ""
    
    var filtered_arr:[String] = [String]()
    
    
    var longPressRecognizer: UILongPressGestureRecognizer?
    

    @IBOutlet var actAndSceneLabel: UILabel!
    @IBOutlet var characterLabel: UILabel!
    @IBOutlet weak var quotationTextView: UILabel!
    
    @IBAction func Btn_tell(_ sender: AnyObject) {
        
        print("clicked"+quotation.ctell)
        
        let url1 = URL(string: "tel://"+self.actAndSceneLabel.text!)
        UIApplication.shared.openURL(url1!)
    }
    @IBAction func Btn_phone(_ sender: AnyObject) {
        
        let url1 = URL(string: "tel://"+self.quotationTextView.text!)
        UIApplication.shared.openURL(url1!)
    }

    @IBAction func Btn_sms(_ sender: AnyObject) {
        
        let url1 = URL(string: "sms://"+self.quotationTextView.text!)
        UIApplication.shared.openURL(url1!)
    }
    
        // 设置语录
    func setTheQuotation(_ newQuotation: Quotation) {
        
        quotation = newQuotation
            
        self.characterLabel.text = quotation.aname
        self.actAndSceneLabel.text = quotation.ctell
        self.quotationTextView.text = quotation.bphone
    }
    func setSearchQuatation(_ newQuotation: String) {
        filtered = newQuotation
        
        filtered_arr = filtered.components(separatedBy: ",")
        print("测试888888888",filtered_arr)
        self.characterLabel.text = filtered_arr[0]
        self.actAndSceneLabel.text = filtered_arr[2]
        self.quotationTextView.text = filtered_arr[1]
        
    }
        
}
