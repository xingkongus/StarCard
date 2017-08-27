//
//  ViewController.swift
//  StarCard
//
//  Created by Semper Idem on 14-10-22.
//  Copyright (c) 2014年 星夜暮晨. All rights reserved.
//

import UIKit


class EmailMenuItem: UIMenuItem{
    var indexPath: IndexPath!
}

class ViewController: UIViewController,SectionHeaderViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var my_view: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
        var countrySearchController = UISearchController()
    let SectionHeaderViewIdentifier = "SectionHeaderViewIdentifier"
    var plays:NSArray!
    var sectionInfoArray:NSMutableArray!
    var pinchedIndexPath:IndexPath!
    var opensectionindex:Int!
    var initialPinchHeight:CGFloat!
    
    var playe:NSMutableArray?
    
    var sectionHeaderView:SectionHeaderView!
    //数据源
    var data:NSMutableArray?
    
    //搜索匹配的结果
    var filtered:[String] = [String]()
    //是否显示搜索结果
    var shouldShowSearchResults = false
    
    var str_arr:String = ""
    
    var arr_message:[String] = [String]()
    
    var search_text = ""
    
    var string_cell = ""
    
    var arr_number:[Int] = [Int]()
    
    var arr_rows:[Int] = [Int]()
    
    var count_section = 0
    
    var arr_str:[String] = [String]()
    
    var arr_section:[String] = [String]()
    
    var arr_arr:[[String]] = [[String]]()
    
    var actionButton:ActionButton!
    
    
    
    //当缩放手势同时改变了所有单元格高度时使用uniformRowHeight
    var uniformRowHeight: Int!
    
    let DefaultRowHeight = 88
    let HeaderHeight = 48
    
    
    var trashItem : UIBarButtonItem {
        return UIBarButtonItem(title:"星名片", style:.done, target: self, action: #selector(ViewController.usclick(_:)))
    }
    
    
    func trashclick(_ barItem: UIBarButtonItem) {
        print("您按了删除")
    }
    
    var shareItem : UIBarButtonItem {
        return UIBarButtonItem(title:"退出登录", style:.done, target: self, action: #selector(ViewController.shareclick(_:)))
    }
    
    
    var spaceItem : UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        //注册点击事件
//        view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(Login.handleTap(_:))))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
        //初始化searchBar
        
        self.searchBar.backgroundColor = UIColor(red:0.02, green:0.48, blue:1, alpha:0)
        self.searchBar.delegate = self
        
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        my_view.backgroundColor = UIColor(red:0.02, green:0.48, blue:1, alpha:0)
                
        
        // 设置Header的高度
        self.tableView.sectionHeaderHeight = CGFloat(HeaderHeight)
        self.tableView.rowHeight = 88;
        
        // 分节信息数组在viewWillUnload方法中将被销毁，因此在这里设置Header的默认高度是可行的。如果您想要保留分节信息等内容，可以在指定初始化器当中设置初始值。
        
        self.uniformRowHeight = DefaultRowHeight
        self.opensectionindex = NSNotFound
        
        //加载首项
        
        let sectionHeaderNib: UINib = UINib(nibName: "SectionHeaderView", bundle: nil)

        self.tableView.register(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: SectionHeaderViewIdentifier)

        plays = played()
        
        print("最后的")
        print(plays)
        let tb_bgname = UIImage(named: "launchScreen")
        let tb_img = UIImageView(image: tb_bgname)
        self.tableView.backgroundView = tb_img
        
        
        let twitterImage = UIImage(named: "twitter_icon.png")!
        let plusImage = UIImage(named: "googleplus_icon.png")!
        
        let twitter = ActionButtonItem(title: "Twitter", image: twitterImage)
        twitter.action = { item in print("Twitter...") }
        
        let google = ActionButtonItem(title: "Google Plus", image: plusImage)
        google.action = { item in print("Google Plus...") }
        
        actionButton = ActionButton(attachedToView: self.view, items: [twitter, google])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.setTitle("+", forState: UIControlState())
        
        actionButton.backgroundColor = UIColor(red: 238.0/255.0, green: 130.0/255.0, blue: 34.0/255.0, alpha:1.0)

        
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
           }
    
    override var canBecomeFirstResponder : Bool {
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if plays == [] {
            warring()
        }
        
        // 检查分节信息数组是否已被创建，如果其已创建，则再检查节的数量是否仍然匹配当前节的数量。通常情况下，您需要保持分节信息与单元格、分节格同步u过您要允许在表视图中编辑信息，您需要在编辑操作中适当更新分节信息。
        
        if self.sectionInfoArray == nil || self.sectionInfoArray.count != self.numberOfSections(in: self.tableView) {
            
            //对于每个场次来说，需要为每个单元格设立一个一致的、包含默认高度的SectionInfo对象。
            let infoArray = NSMutableArray()
            
            for play in self.plays {
                var i = 0
                
                var dic = (play as! Play).quotations
                let sectionInfo = SectionInfo()
                sectionInfo.play = play as! Play
                sectionInfo.open = false
                
                let defaultRowHeight = DefaultRowHeight
                
                //获取行数
                
                    
                    let countOfQuotations = sectionInfo.play.quotations.count
                    
                    //为每行设置高度
                    for i in 0 ..< countOfQuotations {
                        sectionInfo.insertObject(defaultRowHeight as AnyObject, inRowHeightsAtIndex: i)
                    }
                     print("测试countOfQuotations")

                
                
                infoArray.add(sectionInfo)
            }
            
            self.sectionInfoArray  = infoArray
            
            
        }
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // 这个方法返回 tableview 有多少个section
        
            return self.plays.count
        
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.search_text == "" {
            // 这个方法返回对应的section有多少个元素，也就是多少行
            let sectionInfo: SectionInfo = self.sectionInfoArray[section] as! SectionInfo
            
            
            let numStoriesInSection = sectionInfo.play.quotations.count
            let sectionOpen = sectionInfo.open!
            
            
            //如果sectionOpen = false返回0，为true 则返回相应数量
            print("测试section11111111",numStoriesInSection)
            return sectionOpen ? numStoriesInSection : 0
            
        }
        else{
            let sectionInfo:SectionInfo = self.sectionInfoArray[section] as! SectionInfo
            let numStoriesInSection = self.arr_rows[section]
            
            var sectionOpen = sectionInfo.open!
            
            //sectionOpen = true
            
            //如果sectionOpen = false返回0，为true 则返回相应数量
            print("测试section11111111",numStoriesInSection)
            return sectionOpen ? numStoriesInSection : 0
        }
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 返回指定的row 的cell。这个地方是比较关键的地方，一般在这个地方来定制各种个性化的 cell元素。这里只是使用最简单最基本的cell 类型。其中有一个主标题 cell.textLabel 还有一个副标题cell.detailTextLabel,  还有一个 image在最前头 叫cell.imageView.  还可以设置右边的图标，通过cell.accessoryType 可以设置是饱满的向右的蓝色箭头，还是单薄的向右箭头，还是勾勾标记。
        
        let QuoteCellIdentifier = "QuoteCellIdentifier"
        let cell: QuoteCell = tableView.dequeueReusableCell(withIdentifier: QuoteCellIdentifier) as! QuoteCell
        
        if self.search_text == "" {
            //部门
            let play:Play = (self.sectionInfoArray[(indexPath as NSIndexPath).section] as! SectionInfo).play
            
            
            //将值赋给cell
            //部门成员
            cell.quotation = play.quotations[(indexPath as NSIndexPath).row] as! Quotation
            //部门成员详细信息
            cell.setTheQuotation(cell.quotation)
            cell.backgroundColor = UIColor(red:0.02, green:0.48, blue:1, alpha:0)
            print("测试33333",play.quotations)
            

        }
        else{
//                self.arr_section.append(filtered[self.count_section])
//                self.count_section = self.count_section + 1
//                print("测试count_section",self.count_section)
            self.arr_section = self.arr_arr[(indexPath as NSIndexPath).section] 
            
            
            
            cell.filtered = self.arr_section[(indexPath as NSIndexPath).row]
            
            cell.setSearchQuatation(cell.filtered)
            cell.backgroundColor = UIColor(red:0.02, green:0.48, blue:1, alpha:0)
            
        }
        
        return cell
            }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的 section header 的view，如果没有，这个函数可以不返回view
        
            let sectionHeaderView: SectionHeaderView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderViewIdentifier) as! SectionHeaderView
            let sectionInfo: SectionInfo = self.sectionInfoArray[section] as! SectionInfo
            sectionInfo.headerView = sectionHeaderView
            
            sectionHeaderView.titleLabel.text = sectionInfo.play.name
            sectionHeaderView.disclosureButton.isSelected = false
            sectionHeaderView.backgroundColor = UIColor(red:0.02, green:0.48, blue:1, alpha:0)
            sectionHeaderView.section = section
            sectionHeaderView.delegate = self
            
            
            return sectionHeaderView

        
        
            }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        // 这个方法返回指定的 row 的高度
//        let sectionInfo: SectionInfo = self.sectionInfoArray[(indexPath as NSIndexPath).section] as! SectionInfo
//
//        return CGFloat(sectionInfo.objectInRowHeightsAtIndex((indexPath as NSIndexPath).row) as! NSNumber)
//        //又或者，返回单元格的行高
//    }
    
    // _________________________________________________________________________
    // SectionHeaderViewDelegate
    
    func sectionHeaderView(_ sectionHeaderView: SectionHeaderView, sectionOpened: Int) {
        
        
        
        
        if self.search_text == "" {
            //获取哪个section被打开
            
            var sectionInfo: SectionInfo = self.sectionInfoArray[sectionOpened] as! SectionInfo
            print("测试sectionInfoArray",self.sectionInfoArray)
            print("测试sectionOpened",sectionOpened)
            sectionInfo.open = true
            //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
            
            var countOfRowsToInsert = sectionInfo.play.quotations.count
            var indexPathsToInsert = NSMutableArray()
            
            for i in 0 ..< countOfRowsToInsert {
                indexPathsToInsert.add(IndexPath(row: i, section: sectionOpened))
            }
            
            // 创建一个包含单元格索引路径的数组来实现删除单元格的操作：这些路径对应之前打开的节的单元格
            
            var indexPathsToDelete = NSMutableArray()
            
            var previousOpenSectionIndex = self.opensectionindex
            if previousOpenSectionIndex != NSNotFound {
                
                var previousOpenSection: SectionInfo = self.sectionInfoArray[previousOpenSectionIndex!] as! SectionInfo
                previousOpenSection.open = false
                previousOpenSection.headerView.toggleOpenWithUserAction(false)
                var countOfRowsToDelete = previousOpenSection.play.quotations.count
                for i in 0 ..< countOfRowsToDelete {
                    indexPathsToDelete.add(IndexPath(row: i, section: previousOpenSectionIndex!))
                }
            }
            // 设计动画，以便让表格的打开和关闭拥有一个流畅（很屌）的效果
            var insertAnimation: UITableViewRowAnimation
            var deleteAnimation: UITableViewRowAnimation
            if previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex! {
                insertAnimation = UITableViewRowAnimation.top
                deleteAnimation = UITableViewRowAnimation.bottom
            }else{
                insertAnimation = UITableViewRowAnimation.bottom
                deleteAnimation = UITableViewRowAnimation.top
            }
            
            // 应用单元格的更新
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: indexPathsToDelete as AnyObject as! [IndexPath], with: deleteAnimation)
            self.tableView.insertRows(at: indexPathsToInsert as AnyObject as! [IndexPath], with: insertAnimation)
            
            self.opensectionindex = sectionOpened
            
            self.tableView.endUpdates()


        }
        else{
            

            // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
            let sectionInfo: SectionInfo = self.sectionInfoArray[sectionOpened] as! SectionInfo
            
            sectionInfo.open = false
            let countOfRowsToDelete = self.tableView.numberOfRows(inSection: sectionOpened)
            
            if countOfRowsToDelete > 0 {
                let indexPathsToDelete = NSMutableArray()
                for i in 0 ..< countOfRowsToDelete {
                    indexPathsToDelete.add(IndexPath(row: i, section: sectionOpened))
                }
                self.tableView.deleteRows(at: indexPathsToDelete as AnyObject as! [IndexPath], with: UITableViewRowAnimation.top)
            }
            self.opensectionindex = NSNotFound
        }
            }
    
    func sectionHeaderView(_ sectionHeaderView: SectionHeaderView, sectionClosed: Int) {
        if self.search_text == "" {
            // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
            let sectionInfo: SectionInfo = self.sectionInfoArray[sectionClosed] as! SectionInfo
            
            sectionInfo.open = false
            let countOfRowsToDelete = self.tableView.numberOfRows(inSection: sectionClosed)
            
            if countOfRowsToDelete > 0 {
                let indexPathsToDelete = NSMutableArray()
                for i in 0 ..< countOfRowsToDelete {
                    indexPathsToDelete.add(IndexPath(row: i, section: sectionClosed))
                }
                self.tableView.deleteRows(at: indexPathsToDelete as AnyObject as! [IndexPath], with: UITableViewRowAnimation.top)
            }
            self.opensectionindex = NSNotFound
        }
        else{
            //获取哪个section被打开
            
            var sectionInfo: SectionInfo = self.sectionInfoArray[sectionClosed] as! SectionInfo
            
            sectionInfo.open = true
            //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
            
            var countOfRowsToInsert = self.arr_rows[sectionClosed]
            var indexPathsToInsert = NSMutableArray()
            
            for i in 0 ..< countOfRowsToInsert {
                indexPathsToInsert.add(IndexPath(row: i, section: sectionClosed))
            }
                        // 设计动画，以便让表格的打开和关闭拥有一个流畅（很屌）的效果
            var insertAnimation: UITableViewRowAnimation
            var deleteAnimation: UITableViewRowAnimation
            
                insertAnimation = UITableViewRowAnimation.bottom
                deleteAnimation = UITableViewRowAnimation.top
            
            
            // 应用单元格的更新
            self.tableView.beginUpdates()
           
            self.tableView.insertRows(at: indexPathsToInsert as AnyObject as! [IndexPath], with: insertAnimation)
            
            self.opensectionindex = sectionClosed
            
            self.tableView.endUpdates()
            
        }
        
    }
    
    
    func played() -> NSArray {
             if playe == nil {
            var base = BaseClass()
            
            
//            let url = NSBundle.mainBundle().URLForResource("PlaysAndQuotations", withExtension: "plist")
//            let playDictionariesArray = NSArray(contentsOfURL: url!)
//            
            var arr_name = base.cacheGetArray("Root")
            
            var myName:AnyObject? = NSKeyedUnarchiver.unarchiveObject(with: arr_name as! Data) as AnyObject?
            
            var playDictionariesArray = myName as? NSArray
            
            var i = 0;
            
                var number = 0;
                
                        
            //print("大家快来",playDictionariesArray)
            playe = NSMutableArray(capacity: playDictionariesArray!.count)
            
            for playDictionary in playDictionariesArray! {
                
                let play: Play! = Play()
                let result = playDictionary as? NSDictionary
                
                play.name = result?["Playname"]  as! String
                print("测试name",play.name)
                print("测试result",result)
                
                let quotationDictionaries:NSArray = result?["quotations"] as! NSArray
                number = number + quotationDictionaries.count
                self.arr_number.append(number)
                print("测试arr_result",self.arr_number)
                
                let quotations = NSMutableArray(capacity: quotationDictionaries.count)
                
                for quotationDictionary in quotationDictionaries {
                    
                    let quotationDic:NSDictionary = quotationDictionary as! NSDictionary
                    let quotation: Quotation = Quotation()

                    quotation.setValuesForKeys(quotationDic as AnyObject as! [String : AnyObject])
                    quotations.add(quotation)
                    quotationDic[""]
                    i = i+1;
                    self.str_arr = "\(quotation.aname),\(quotation.bphone),\(quotation.ctell),\(i)"
                    
                    self.arr_message.append(self.str_arr)
                    print("测试66666666",self.arr_message)
                    
                }
                print("测试444444",quotations)
                
                
                play.quotations = quotations
                playe!.add(play)
            }
                var dd = self.arr_message.filter({ (ss) -> Bool in
                    return ss.contains("桂")
                })
                print("测试77777777777",dd)
        }
        
        return playe!
    }
    func usclick(_ barItem:UIBarButtonItem) {
        print("您按了分享")
        let alertController = UIAlertController(title: "关于我们",
                                                message: "如果您有什么问题，请联系我们：1072955124@qq.com", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "确定", style: .default,
                                     handler: {
                                        action in
                                        print("点击了确定")
                                        
                                        
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func shareclick(_ barItem:UIBarButtonItem) {
        print("您按了分享")
        let alertController = UIAlertController(title: "系统提示",
                                                message: "您确定要退出登录吗0.0？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
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
                                        let myStoryBoard = self.storyboard
                                        
                                        let anotherView:UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "get"))! as UIViewController
                                        self.present(anotherView, animated: true, completion: nil)
                                        
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func warring() {
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
    //搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.arr_arr = [[String]]()
        if searchBar.text != "" {
            for i in 0..<sectionInfoArray.count {
                let sectionInfo:SectionInfo = self.sectionInfoArray[i] as! SectionInfo
                sectionInfo.open = true
                print("测试sectionInfoArray.count",sectionInfo.open)
            }
            
        }
        else{
            for i in 0..<sectionInfoArray.count {
                let sectionInfo:SectionInfo = self.sectionInfoArray[i] as! SectionInfo
                sectionInfo.open = false
            }
            print("测试sectionInfoArray.count2",sectionInfoArray.count)
            
        }
        
        
        
        
        
        self.search_text = searchBar.text!
        self.filtered = self.arr_message.filter({ (ss) -> Bool in
            return ss.contains(self.search_text)
            
        })
        
        var count:Int = 0
        var a = 0
        var final_count = 0
        var zhong_count = 0
        var sum_count = 0
        self.arr_rows = [Int]()
        for i in 0..<self.arr_number.count{
            for k in 0..<self.filtered.count{
                var str = self.filtered[k].components(separatedBy: ",")
                
                var number:Int = Int(str[3])!
                if a <= k {
                    if number < arr_number[i]+1{
                        
                        
                        self.arr_str.append(self.filtered[a])
                        a = a + 1
                        
                        
                        
                        
                        
                    }
                    
                }
                if number < arr_number[i]+1{
                    count = count + 1
                }
                
                
                
                
                
            }
            self.arr_arr.append(self.arr_str)
            self.arr_str = [String]()
            print("测试arr_arr",arr_arr)
            final_count = count - sum_count - zhong_count
            zhong_count = count
            sum_count = sum_count + final_count
            self.arr_rows.append(final_count)
            print("测试arr_rows",self.arr_rows)
        }
        print(self.search_text)
        print("测试filtered",self.filtered)
        self.tableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

    
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("收回键盘")
            searchBar.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

    
}

