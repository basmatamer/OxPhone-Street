//
//  editProfile.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/16/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class editProfile: UIViewController {

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
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var add: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBAction func saveEdits(_ sender: Any) {
        
        var name = username.text
        var pass=password.text
        var pass2=passwordConfirm.text
        var em = email.text
        var ph = phone.text
        var addr = add.text
        var cou=country.text
        
        let session = URLSession.shared
        var S="http://10.40.42.91:3000/edit_profile?newname="
        S=S+name!+"&email="+em!+"&password="
        S=S+pass!+"&mobilenumber="+ph!
        S=S+"&address="+addr!
        S=S+"&customer_ID="+"1"
        print (S)
        let url = URL(string:S )!
        print(url)
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
                print(string) //JSONSerialization
            }
        }
        task.resume()
        
        
    }
    
}
    

