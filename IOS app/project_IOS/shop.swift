//
//  ViewController10.swift
//  project_design
//
//  Created by Mohamed A Tawfik on Jul/14/18.
//  Copyright © 2018 Aya_Basma_Habiba. All rights reserved.
//

import UIKit

class shop: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!

   // @IBOutlet weak var no_orders: UILabel!
  //  @IBOutlet weak var phone: UILabel!
 //   @IBOutlet weak var location: UILabel!
 //   @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    var images:[String] = ["https://c1.staticflickr.com/5/4636/25316407448_de5fbf183d_o.jpg","https://i.redd.it/tpsnoz5bzo501.jpg", "https://i.redd.it/qn7f9oqu7o501.jpg", "https://i.redd.it/j6myfqglup501.jpg","https://i.redd.it/0h2gm1ix6p501.jpg", "https://i.redd.it/k98uzl68eh501.jpg", "https://i.redd.it/glin0nwndo501.jpg","https://i.redd.it/obx4zydshg601.jpg", "https://i.imgur.com/ZcLLrkY.jpg", "https://i.redd.it/glin0nwndo501.jpg","https://i.redd.it/obx4zydshg601.jpg", "https://i.imgur.com/ZcLLrkY.jpg"]
    
    var place:String = ""
    var shop_image:String = ""
    var number:String = ""
    var orders:Int = 0
    var rating:String = ""
    var shop_name:String = ""
    var products:[item2] = []
    var shop_id:String = "1"
    var mUrls:[String] = []
    var mNames:[String] = []
    var p_ids:[String] = []
    var item_name:String = ""
    var shop_admin_id:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.delegate=self
        collectionView.dataSource=self
        products.removeAll()
        shop_name.removeAll()
        rating.removeAll()
        orders = 0
        place.removeAll()
        number.removeAll()
        shop_image.removeAll()
        mUrls.removeAll()
        mNames.removeAll()
        makeGetCall()
//        profile.layer.borderWidth = 0.5
//        profile.layer.masksToBounds = false
//        profile.layer.borderColor = UIColor.black.cgColor
//        profile.layer.cornerRadius = profile.frame.height/2
//        profile.clipsToBounds = true
        let width =  ((collectionView!.frame).width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width: 100,height: 100)
        layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStarImage(starNumber: Int, forRating rating: Int) -> String {
        if rating >= starNumber {
            return "stargold"
        } else {
            return "starwhite"
        }
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.products.removeAll()
        return mUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item_cell", for: indexPath) as! CollectionViewCell_item
        get_image(mUrls[indexPath.row], cell.img)
        print("image url",mUrls[indexPath.row])
        //cell.img.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func makeGetCall() {
        
        var info: [MyObject]=[]
        print("in")
        let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/get_shop?s_id="+shop_id)!
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
                // print(string) //JSONSerialization
                
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                
                for dayData in json!{
                    let areaObj = MyObject()
                    
                    if let areaName = dayData["no_order"] as? Int{
                        areaObj.no_order = areaName
                    }
                    
                    if let areaCode = dayData["name"] as? String{
                        areaObj.name = areaCode
                    }
                    
                    if let areaName = dayData["rating"] as? String{
                        areaObj.rating = areaName
                    }
                    
                    if let areaName = dayData["address"] as? String{
                        areaObj.address = areaName
                    }
                    
                    if let areaName = dayData["image_url"] as? String{
                        areaObj.image_url = areaName
                    }
                    
                    if let areaName = dayData["landline"] as? String{
                        areaObj.landline = areaName
                    }
                    if let areaName = dayData["s_admin_id"] as? Int{
                        areaObj.shop_admin_id = areaName
                    }
                    info.append(areaObj)
                }
                self.products.removeAll()
                var i=0
                while (i<info.count)
                {
                    self.shop_name = info[i].name
                    self.shop_admin_id = info[i].shop_admin_id
                    self.place = info[i].address
                    self.rating = info[i].rating
                    self.shop_image = info[i].image_url
                    self.number = info[i].landline
                    self.orders = info[i].no_order
                    
                    let session1 = URLSession.shared
                    let url1 = URL(string: "http://10.40.42.91:3000/get_shop_products?shop_id="+self.shop_id)!
                    print(url1)
                    let task1 = session1.dataTask(with: url1) { (data1, _, _) -> Void in
                        if let data1 = data1 {
                            let string1 = String(data: data1, encoding: String.Encoding.utf8)
                            //   print(string1) //JSONSerialization
                            
                            
                            let json1 = try! JSONSerialization.jsonObject(with: data1, options: []) as? [[String:Any]]
                            
                            for dayData in json1!{
                                let areaObj = item2()
                                if let v0 = dayData["p_id"] as? Int{
                                    areaObj.id = v0
                                }
                                if let v1 = dayData["name"] as? String{
                                    areaObj.name = v1
                                }
                                if let v2 = dayData["price"] as? String{
                                    areaObj.price = v2
                                }
                                if let v3 = dayData["rating"] as? String{
                                    areaObj.rating = v3
                                }
                                if let v4 = dayData["availability"] as? String{
                                    areaObj.av = v4
                                }
                                if let v5 = dayData["numberinstock"] as? String{
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
                                if let v10 = dayData["category_id"] as? String{
                                    areaObj.cat = v10
                                }
                                if let v11 = dayData["shop_id"] as? String{
                                    areaObj.shop = v11
                                }
                                
                                self.products.append(areaObj)
                            }
                        }
                        var j=0;
                        self.mUrls.removeAll()
                        self.mNames.removeAll()
                        while (j<self.products.count)
                        {
                            self.mUrls.append(self.products[j].img)
                            self.mNames.append(self.products[j].name)
                            self.p_ids.append(String(self.products[j].id))
                            j=j+1
                        }
                        DispatchQueue.main.async {
//                            self.location.text = self.place
//                            self.phone.text = self.number
//                            self.no_orders.text = String(self.orders)
//                            self.get_image(self.shop_image, self.profile)
//                            self.star1.image = UIImage(named: self.getStarImage(starNumber: 1, forRating: Int(self.rating)!))
//                            self.star2.image = UIImage(named: self.getStarImage(starNumber: 2, forRating: Int(self.rating)!))
//                            self.star3.image = UIImage(named: self.getStarImage(starNumber: 3, forRating: Int(self.rating)!))
//                            self.star4.image = UIImage(named: self.getStarImage(starNumber: 4, forRating: Int(self.rating)!))
//                            self.star5.image = UIImage(named: self.getStarImage(starNumber: 5, forRating: Int(self.rating)!))
                            self.collectionView.reloadData()
                        }
                    }
                    task1.resume()
                    i=i+1
                }
            }
        }
        
        task.resume()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        item_name = mNames[indexPath.row]
        //self.performSegue(withIdentifier: "from_10_11", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? ViewController11
        {
            print("after detail")
            detail.item_name = item_name
            detail.shop_id = shop_id
            detail.shop_admin_id = shop_admin_id
            print("after detail con", detail)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
