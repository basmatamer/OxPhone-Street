//
//  cart.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//


import UIKit

class cart: UIViewController , UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var price_cal: UILabel!
    
    var total_cal:Int = 0
    var mNames:[String] = []
    var mItems:[String] = []
    var mPrices:[String] = []
    var mPic:[String] = []
    var mcol:[String] = []
    var myCart: [item]=[]
    var ids: [Int]=[]
    var ps: [Int]=[]
    @IBOutlet weak var myTable: UITableView!


    override func viewDidAppear(_ animated: Bool) {
        myTable.delegate=self
        myTable.dataSource=self
        mNames.removeAll()
        mItems.removeAll()
        mPrices.removeAll()
        mPic.removeAll()
        myCart.removeAll()
        mcol.removeAll()
        
        makeGetCall()
    
        total_cal = getTotal()
        price_cal.text = String(total_cal)
        
    }
    override func viewDidLoad() {

    }

    
    
    func makeGetCall() {
        
        var IDs: [MyObject]=[]
        print("in")
        let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/get_cart?cart_cu_id="+MAINID)!
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
               // print(string) //JSONSerialization
                
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                for dayData in json!{
                    let areaObj = MyObject()
                    
                    if let areaCode = dayData["cart_cu_id"] as? Int{
                        areaObj.cart_cu_id = areaCode
                    }
                    
                    if let areaName = dayData["cart_p_id"] as? Int{
                        areaObj.cart_p_id = areaName
                    }
                
                    IDs.append(areaObj)
                }
                self.myCart.removeAll()
                var i=0;
                while (i<IDs.count)
                {
                    let session1 = URLSession.shared
                    let url1 = URL(string: "http://10.40.42.91:3000/get_product_info?p_id="+String(IDs[i].cart_p_id))!
                    print(url1)
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
                            }
                        }
                        var j=0;
                        self.ids.removeAll()
                        while (j<self.myCart.count)
                        {
                            self.mPic.append(self.myCart[j].img)
                            self.mPrices.append(String(self.myCart[j].price))
                            self.mNames.append(String(self.myCart[j].name))
                            self.mItems.append(self.myCart[j].size)
                            self.mcol.append(self.myCart[j].color)
                            self.ids.append(self.myCart[j].id)
                            self.ps.append(self.myCart[j].price)
                            j=j+1
                        }
                        // put data into table
                        
                        
                        
                        DispatchQueue.main.async {
                            self.total_cal = self.getTotal()
                            self.price_cal.text = String(self.total_cal)
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
 




    func getTotal() -> Int {
        var cal_total: Int = 0
        for i in mPrices
        {
            cal_total = cal_total + Int(i)!
        }
        return cal_total
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("GAZAR",mNames.count)
        self.myCart.removeAll()
        return mNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_act8", for: indexPath) as! list_act8
        get_image(mPic[indexPath.row], cell.profile)
        cell.price.text = mPrices[indexPath.row]
        cell.shop_name.text = mNames[indexPath.row]
        cell.item_name.text = mcol[indexPath.row]
        cell.order_date.text = mItems[indexPath.row]
        return cell
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
    @IBAction func checkout(_ sender: Any) {
        
        
        //call API to delete stuff from bag and put in history
        var i=0;
        while (i<ids.count)
        {
            let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/delete_cart_item?cart_cu_id="+MAINID+"&cart_p_id="+String(ids[i]))!
            print(url)
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
                print(string) //JSONSerialization
            }
            }
            task.resume()
            print("GAZAR2",String(ids[i]))
            let session1 = URLSession.shared
            let url1 = URL(string: "http://10.40.42.91:3000/checkout?history_cu_id="+MAINID+"&history_p_id="+String(ids[i])+"&amount_paid="+String(ps[i]))!
            print(url1)
            let task1 = session1.dataTask(with: url1) { (data, _, _) -> Void in
                if let data1 = data {
                    let string = String(data: data1, encoding: String.Encoding.utf8)
                    print(string) //JSONSerialization
        
                }
            }
                task1.resume()
            i=i+1
        }
                self.mNames.removeAll()
                self.mItems.removeAll()
                self.mPrices.removeAll()
                self.mPic.removeAll()
                self.myCart.removeAll()
                self.mcol.removeAll()
            
            DispatchQueue.main.async {
                self.total_cal = self.getTotal()
                self.price_cal.text = String(self.total_cal)
                self.myTable.reloadData()
        }
    }
}

