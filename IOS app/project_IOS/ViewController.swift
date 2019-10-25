//
//  ViewController.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/10/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//
import UIKit
var shopCat=0;


class ViewController: UIViewController {

    @IBOutlet weak var backCat: UIButton!
    @IBOutlet weak var beauty: UIButton!
    @IBOutlet weak var acc: UIButton!
    @IBOutlet weak var clothes: UIButton!
    @IBOutlet weak var food: UIButton!
   // @IBOutlet weak var sideMenu: NSLayoutConstraint!
    
    var menushowing=false;
    
//    @IBAction func food_p(_ sender: Any) {
//        acc.isHidden=true;
//        beauty.isHidden=true
//        clothes.isHidden=true
//        food.isHidden=true
//
//        backCat.isHidden=false
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backCat.isHidden=true
      //  sideMenu.constant = 0



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
//    @IBAction func backToCat(_ sender: Any) {
//        acc.isHidden=false;
//        beauty.isHidden=false
//        clothes.isHidden=false
//        food.isHidden=false
//
//        backCat.isHidden=true
//
//        
//    }
    
//    @IBAction func menuCntrl(_ sender: Any)
//        {
//    
//                if(menushowing){
//                    sideMenu.constant = -281
//                   // menu.isHidden=true;
//                    menushowing=false
//                }else {
//                   sideMenu.constant = 0
//                //   menu.isHidden=false;
//                    menushowing=true
//                }
//
//                UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
//        }
    
    @IBAction func food_p(_ sender: Any) {
        shopCat=1
    }
    @IBAction func clothes_p(_ sender: Any) {
        shopCat=2
    }
    @IBAction func acc_p(_ sender: Any) {
        shopCat=3
    }
    @IBAction func beauty_p(_ sender: Any) {
        shopCat=4
    }
    
    
}

