//
//  favorite.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/13/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class favorite: UIViewController {
    @IBOutlet weak var pages: UIView!
  //  @IBOutlet weak var items: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // items.isHidden=false;
        pages.isHidden=true;

        // Do any additional setup after loading the view.
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
    @IBAction func items_b(_ sender: Any) {
       // items.isHidden=false;
        pages.isHidden=true;
    }
    @IBAction func pages_b(_ sender: Any) {
      //  items.isHidden=true;
        pages.isHidden=false;
    }
    
}
