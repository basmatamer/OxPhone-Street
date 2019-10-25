//
//  category.swift
//  project_IOS
//
//  Created by MacBook Pro on 7/16/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit

class Category: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_next: UIButton!
    var customer_ID:String = "1"
    //var cat:[String] = ["Food", "Clothes", "Accessories", "Beauty Products"]
    var cat:[String] = ["Bag", "Shoes", "Beauty Products", "Art", "Food", "Accessories",  "Clothes"]
    var checked:[Bool] = []
    var all_cats:[Category_Stuff] = []
    
    func fill_cat() {
        
        for i in cat
        {
            var cs:Category_Stuff = Category_Stuff()
            cs.cat_name = i
            cs.checked = false
            all_cats.append(cs)
            
        }
        print("name", all_cats)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fill_cat()
        //get_cat()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate=self
        tableView.dataSource=self
        all_cats.removeAll()
        fill_cat()
        get_cat()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        all_cats.removeAll()
        return checked.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cat_cell", for: indexPath) as! cat_cell
        print("checked array is", checked)
        cell.label.text = cat[indexPath.row]
        var accessory:UITableViewCellAccessoryType =  UITableViewCellAccessoryType.none
        if checked[indexPath.row] == true
        {
            accessory = UITableViewCellAccessoryType.checkmark
            print("hi")
        }
        cell.accessoryType = accessory
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            delete_cat(id: String(indexPath.row+1))
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            add_cat(id: String(indexPath.row+1))
            
        }
    }
    
    
    func add_cat(id:String)
    {
        let session = URLSession.shared
        let url = URL(string: "http://192.168.1.7:3000/add_preferred_categories?customer_id="+customer_ID+"&category_id="+id)!
        print(url)
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
                print("what is this", string) //JSONSerialization
                
            }
            
            DispatchQueue.main.async {
                
            }
            
        }
        
        task.resume()
    }
    
    func delete_cat(id:String)
    {
        let session = URLSession.shared
        let url = URL(string: "http://192.168.1.10:3000/delete_preferred_categories?customer_id="+customer_ID+"&category_id="+id)!
        print(url)
        let task = session.dataTask(with: url) { (data, _, _) -> Void in
            if let data = data {
                let string = String(data: data, encoding: String.Encoding.utf8)
                print("what is this", string) //JSONSerialization
                
            }
            
            DispatchQueue.main.async {
                
            }
            
        }
        
        task.resume()
    }
    
    func get_cat()
    {
        let session1 = URLSession.shared
        let url1 = URL(string: "http://192.168.1.7:3000/get_preferred_categories?customer_id="+self.customer_ID)!
        print(url1)
        let task1 = session1.dataTask(with: url1) { (data1, _, _) -> Void in
            if let data1 = data1 {
                let string1 = String(data: data1, encoding: String.Encoding.utf8)
                //   print(string1) //JSONSerialization
                
                
                let json1 = try! JSONSerialization.jsonObject(with: data1, options: []) as? [[String:Any]]
                
                for dayData in json1!{
                    let areaObj = Category_Stuff()
                    if let v0 = dayData["RelationCategoryID"] as? Int{
                        //areaObj.cat_name = self.cat[v0]
                        self.all_cats[v0].checked = true
                        print("checked", v0, self.all_cats[v0].checked)
                    }
                    
                }
            }
            var j=0;
            while (j<self.all_cats.count)
            {
                self.checked.append(self.all_cats[j].checked)
                j=j+1
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task1.resume()
    }
    @IBAction func next_pressed(_ sender: Any) {
        //segue here to explore page
        self.performSegue(withIdentifier: "from_cat_explore", sender: nil)
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
