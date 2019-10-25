//
//  favoriteItems.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/12/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class favoriteItems: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    //@IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
       // @IBOutlet weak var collectionView: UICollectionView!
        private let leftAndRightPaddings: CGFloat = 32.0
        private let numberOfItemsPerRow: CGFloat = 3.0
        private let heightAdjustment: CGFloat = 30.0
        
        var images:[String] = ["https://c1.staticflickr.com/5/4636/25316407448_de5fbf183d_o.jpg","https://i.redd.it/tpsnoz5bzo501.jpg", "https://i.redd.it/qn7f9oqu7o501.jpg", "https://i.redd.it/j6myfqglup501.jpg","https://i.redd.it/0h2gm1ix6p501.jpg", "https://i.redd.it/k98uzl68eh501.jpg", "https://i.redd.it/glin0nwndo501.jpg","https://i.redd.it/obx4zydshg601.jpg", "https://i.imgur.com/ZcLLrkY.jpg", "https://i.redd.it/glin0nwndo501.jpg","https://i.redd.it/obx4zydshg601.jpg", "https://i.imgur.com/ZcLLrkY.jpg"]

        override func viewDidLoad() {
            super.viewDidLoad()
            let width =  ((collectionView!.frame).width - leftAndRightPaddings) / numberOfItemsPerRow
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width+heightAdjustment)
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
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item_cell", for: indexPath) as! CollectionViewCell_item
            get_image(images[indexPath.row], cell.img)
            //cell.img.image = UIImage(named: images[indexPath.row])
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
