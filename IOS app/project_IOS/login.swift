//
//  login.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/14/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class login: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBAction func login(_ sender: Any) {
        var name = username.text;
        var pass = password.text
        let session1 = URLSession.shared
        let S1="http://10.40.42.91:3000/get_customerID?customer_name="+name!
        let url1 = URL(string:S1 )!
        print(url1)
        let task1 = session1.dataTask(with: url1) { (data1, _, _) -> Void in
            if let data1 = data1 {
                let string1 = String(data: data1, encoding: String.Encoding.utf8)
                print("ID",string1) //JSONSerialization
                MAINID=string1!;
                
            }
        }
        task1.resume()
    }
    
}
