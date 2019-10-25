//
//  favoritePages.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class favoritePages: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    var mProfile:[String] = ["https://c1.staticflickr.com/5/4636/25316407448_de5fbf183d_o.jpg", "https://i.redd.it/j6myfqglup501.jpg", "https://i.redd.it/glin0nwndo501.jpg"]
    var mLocations:[String] = ["Havasu Falls", "Frozen Lake", "Austrailia"]
    var mOrders:[String] = ["100", "100", "100"]
    var mNumbers:[String] = ["01255877", "01255877", "01255877"]
    var mRatings:[Int] = [5, 4, 3]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_act7", for: indexPath) as! list_act7
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
