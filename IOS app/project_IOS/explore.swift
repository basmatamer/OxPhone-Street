//
//  explore.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class explore: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {

    var mNames:[String] = ["Zara","Bershka","Pull and Bear"]
    var mItems:[String] = ["Pants", "Blouse","Pants"]
    var mPrices:[String] = ["800 LE", "700 LE", "900 LE"]
    var mPic:[String] = ["https://c1.staticflickr.com/5/4636/25316407448_de5fbf183d_o.jpg", "https://i.redd.it/j6myfqglup501.jpg","https://i.redd.it/glin0nwndo501.jpg"]
    
    var mImageUrls:[[String]] = [["https://c1.staticflickr.com/5/4636/25316407448_de5fbf183d_o.jpg", "https://i.redd.it/tpsnoz5bzo501.jpg", "https://i.redd.it/qn7f9oqu7o501.jpg"],
                                 ["https://i.redd.it/j6myfqglup501.jpg","https://i.redd.it/0h2gm1ix6p501.jpg", "https://i.redd.it/k98uzl68eh501.jpg"],
                                 ["https://i.redd.it/glin0nwndo501.jpg","https://i.redd.it/obx4zydshg601.jpg", "https://i.imgur.com/ZcLLrkY.jpg"]]
    var mLocations:[String] = ["Havasu Falls", "Frozen Lake", "Austrailia"]
    var mOrders:[String] = ["100", "100", "100"]
    var mNumbers:[String] = ["01255877", "01255877", "01255877"]
    var mRatings:[Int] = [5, 4, 3]
    var mProfile:[String] = ["https://c1.staticflickr.com/5/4636/25316407448_de5fbf183d_o.jpg", "https://i.redd.it/j6myfqglup501.jpg", "https://i.redd.it/glin0nwndo501.jpg"]
    
    
    @IBOutlet weak var myT: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
     //   myT.text="Explore"
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
    
    
   
    
    private func hi()
    {
        let  titleViewText = UILabel()
        titleViewText.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleViewText.text = "Explore"
        titleViewText.textAlignment = NSTextAlignment.center
        navigationItem.titleView = titleViewText
        navigationController?.navigationBar.backgroundColor = .blue
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
    
    func getStarImage(starNumber: Int, forRating rating: Int) -> String {
        if rating >= starNumber {
            return "stargold"
        } else {
            return "starwhite"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "act5_CollectionViewCell", for: indexPath) as! act5_CollectionViewCell
        get_image(mImageUrls[indexPath.row][0], cell.image1)
        get_image(mImageUrls[indexPath.row][1], cell.image2)
        get_image(mImageUrls[indexPath.row][2], cell.image3)
        cell.location.text = mLocations[indexPath.row]
        cell.orders.text = mOrders[indexPath.row]
        cell.phone.text = mNumbers[indexPath.row]
        get_image(mProfile[indexPath.row], cell.profile)
        //rating
        cell.star1.image = UIImage(named: getStarImage(starNumber: 1, forRating: mRatings[indexPath.row]))
        cell.star2.image = UIImage(named: getStarImage(starNumber: 2, forRating: mRatings[indexPath.row]))
        cell.star3.image = UIImage(named: getStarImage(starNumber: 3, forRating: mRatings[indexPath.row]))
        cell.star4.image = UIImage(named: getStarImage(starNumber: 4, forRating: mRatings[indexPath.row]))
        cell.star5.image = UIImage(named: getStarImage(starNumber: 5, forRating: mRatings[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        get_image(mPic[indexPath.row], cell.profile)
        cell.price.text = mPrices[indexPath.row]
        cell.shop_name.text = mNames[indexPath.row]
        cell.item_name.text = mItems[indexPath.row]
        return cell
    }
    //var menushowing=false;
    
    
//    @IBAction func menuCntrl(_ sender: Any)
//    {
//
//        if(menushowing){
//            menu.constant = -281
//            sideMenu.isHidden=true;
//            menushowing=false
//
//        }else {
//            menu.constant = 0
//            sideMenu.isHidden=false;
//            menushowing=true
//
//        }
//
//        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
//    }


}
