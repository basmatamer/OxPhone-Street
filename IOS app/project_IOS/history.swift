//
//  history.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

class history:  UIViewController, UITableViewDataSource, UITableViewDelegate {
   var menushowing=false;

    @IBOutlet weak var menu: UIView!
    //@IBOutlet weak var sideMenu: NSLayoutConstraint!
    
    var mNames:[String] = []
    var mItems:[String] = []
    var mPrices:[Int] = []
    var money: [Int]=[]
    var dates:[Date]=[]
    var mPic:[String] = []
    var mcol:[String] = []
    var mOrders:[Date]=[]
    var myCart: [item]=[]
    var ids: [Int]=[]
    
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        myTable.delegate=self
        myTable.dataSource=self
        mNames.removeAll()
        mItems.removeAll()
        mPrices.removeAll()
        mPic.removeAll()
        myCart.removeAll()
        mOrders.removeAll()
        mcol.removeAll()
        money.removeAll()
        dates.removeAll()
        
        makeGetCall()
        
    }

//    @IBOutlet weak var main: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     //   sideMenu.constant=0;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func get_image(_ url_str:String, _ imageView:UIImageView)
    {
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (
            data, response, error) in
            if data != nil
            {
                let image = UIImage(data: data!)
                if(image != nil)
                {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                        imageView.alpha = 0
                        UIView.animate(withDuration: 2.5, animations: {
                            imageView.alpha = 1.0
                        })
                    })
                }
            }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myCart.removeAll()

      //  mOrders.removeAll()
     //   mPrices.removeAll()
        return mNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_act8", for: indexPath) as! list_act8
        get_image(mPic[indexPath.row], cell.profile)
        cell.price.text = String(money[indexPath.row])
        cell.shop_name.text = mItems[indexPath.row]
        cell.item_name.text = mNames[indexPath.row]
        cell.order_date.text = dates[indexPath.row].toString(dateFormat: "dd-MM")
        return cell
    }

//    @IBAction func menuCntrl(_ sender: Any)
//    {
//
//            if(menushowing){
//                sideMenu.constant = -281
//                menu.isHidden=true;
//                menushowing=false
//            }else {
//                sideMenu.constant = 0
//                menu.isHidden=false;
//                menushowing=true
//            }
//
//            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
//    }
    
    
    func makeGetCall() {
        
        var IDs: [MyObject]=[]
        print("in")
        let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/get_history?history_cu_id="+MAINID)!
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
                 print(string) //JSONSerialization
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                
                for dayData in json!{
                    let areaObj = MyObject()
                    
                    if let areaCode = dayData["history_cu_id"] as? Int{
                        areaObj.cart_cu_id = areaCode
                    }
                    
                    if let areaName = dayData["history_p_id"] as? Int{
                        areaObj.cart_p_id = areaName
                    }
                    
                    if let areaName1 = dayData["order_date"] as? Date{
                        areaObj.d = areaName1
                    }
                    
                    if let areaName2 = dayData["amount_paid"] as? Int{
                        areaObj.money = areaName2
                        print("money",areaObj.money)
                    }
                    
                    IDs.append(areaObj)
                }
                self.myCart.removeAll()
                var i=0;
                while (i<IDs.count)
                {
                    let session1 = URLSession.shared
                    let url1 = URL(string: "http://10.40.42.91:3000/get_product_info?p_id="+String(IDs[i].cart_p_id))!
                    self.money.append(IDs[i].money)
                    self.dates.append(IDs[i].d)
                    print("gazar",self.money.count)

                    let task1 = session1.dataTask(with: url1) { (data1, _, _) -> Void in
                        if let data1 = data1 {

                            let string1 = String(data: data1, encoding: String.Encoding.utf8)
                            //   print(string1) //JSONSerialization
                            
                            let json1 = try! JSONSerialization.jsonObject(with: data1, options: []) as? [[String:Any]]
                            
                            for dayData in json1!{
                                let areaObj = item()
                                if let v0 = dayData["p_id"] as? Int{
                                    areaObj.id = v0
                                }
                                if let v1 = dayData["name"] as? String{
                                    areaObj.name = v1
                                }
                                if let v2 = dayData["price"] as? Int{
                                    areaObj.price = v2
                                }
                                if let v3 = dayData["rating"] as? Int{
                                    areaObj.rating = v3
                                }
                                if let v4 = dayData["availability"] as? Int{
                                    areaObj.av = v4
                                }
                                if let v5 = dayData["numberinstock"] as? Int{
                                    areaObj.stock = v5
                                }
                                if let v6 = dayData["color"] as? String{
                                    areaObj.color = v6
                                }
                                if let v7 = dayData["size"] as? String{
                                    areaObj.size = v7
                                }
                                if let v8 = dayData["description"] as? String{
                                    areaObj.desc = v8
                                }
                                if let v9 = dayData["image_url"] as? String{
                                    areaObj.img = v9
                                }
                                if let v10 = dayData["category_id"] as? Int{
                                    areaObj.cat = v10
                                }
                                if let v11 = dayData["shop_id"] as? Int{
                                    areaObj.shop = v11
                                }
                                self.myCart.append(areaObj)
                                print("gazar",self.mPrices.count)

                              
                                
                            }
                        }
                        var j=0;
                        while (j<self.myCart.count)
                        {
                            self.mPic.append(self.myCart[j].img)
                           // self.mPrices.append(String(self.myCart[j].price))
                            self.mNames.append(String(self.myCart[j].name))
                            self.mItems.append(self.myCart[j].size)
                            self.mcol.append(self.myCart[j].color)
                            self.ids.append(self.myCart[j].id)
                            
                            j=j+1
                        }
                        // put data into table
                        
                        
                        
                        DispatchQueue.main.async {
                            self.myTable.reloadData()
                        }
                        //self.myCart.removeAll()
                    }
                    task1.resume()
                    i=i+1
                }
            }
        }
        task.resume()
    }
}
    

