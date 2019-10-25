
import UIKit

class ViewController11: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView_color: UIPickerView!
    @IBOutlet weak var pickerView_size: UIPickerView!
    
    var counter2:Int = 0
    var counter1:Int = 0
    
    var color_id: Int?
    var size_id: Int?
    var customer_ID:String = MAINID
    var colors:[String] = []
    var sizes:[String] = []
    var name:String="black dress"
    var id:String = ""
    var sa_id:Int = 0
    var desc_item:String = ""
    var img_url:String = ""
    var price_item:String = ""
    var p_ids:[Int] = []
    var product:[item2] = []
    
    var item_name:String?
    var shop_id:String?
    var shop_admin_id:Int?
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cart_Label: UIButton!
    @IBOutlet weak var heart_Label: UIButton!
    
    @IBOutlet weak var product_img: UIImageView!
    
    @IBOutlet weak var buttonLabel_size: UIButton!
    @IBOutlet weak var buttonLabel_color: UIButton!
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count:Int?
        
        if pickerView == self.pickerView_color {
            count = colors.count
        }
        
        if pickerView == self.pickerView_size {
            count =  sizes.count
        }
        
        return count!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title:String?
        if pickerView == self.pickerView_color {
            title = colors[row]
        }
        
        
        if pickerView == self.pickerView_size {
            title = sizes[row]
        }
        
        return title!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView_color {
            buttonLabel_color.setTitle(colors[row], for: .normal)
            self.pickerView_color.isHidden = true
            print("I am here in select size")
            if row  !=  color_id
            {
                counter1 = 0
                self.heart_Label.setBackgroundImage(#imageLiteral(resourceName: "heart"), for: .normal)
                self.cart_Label.setBackgroundImage(#imageLiteral(resourceName: "cart"), for: .normal)
                counter2 = 0
            }
            color_id = row
        }
        
        if pickerView == self.pickerView_size{
            buttonLabel_size.setTitle(sizes[row], for: .normal)
            self.pickerView_size.isHidden = true
            print("I am here in select size")
            if row  !=  size_id
            {
                counter1 = 0
                self.heart_Label.setBackgroundImage(#imageLiteral(resourceName: "heart"), for: .normal)
                self.cart_Label.setBackgroundImage(#imageLiteral(resourceName: "cart"), for: .normal)
                counter2 = 0
            }
            size_id = row
        }
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pickerView_size.dataSource = self
        pickerView_size.delegate = self
        
        pickerView_color.dataSource = self
        pickerView_color.delegate = self
        
        self.pickerView_size.isHidden = true
        self.pickerView_color.isHidden = true
        
        colors.removeAll()
        sizes.removeAll()
        p_ids.removeAll()
        product.removeAll()
        get_product_item()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("hi_appear!")
        if let i = item_name
        {
            //here you should use item name for the navbar title
            name = i
        }
        if let s = shop_id
        {
            id = s
        }
        if let p = shop_admin_id
        {
            sa_id = p
        }
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
    
    func add_cart_item(id:Int)
    {
        let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/add_cart_item?cus_id="+customer_ID+"&p_id="+String(id)+"&sa_id="+String(sa_id))!
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
    
    func delete_cart_item(id:Int)
    {
        let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/delete_cart_item?cus_id="+customer_ID+"&p_id="+String(id)+"&sa_id="+String(sa_id))!
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
    
    func delete_fav_item(id:Int)
    {
        let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/delete_fav_item?cus_id="+customer_ID+"&p_id="+String(id))!
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
    
    func add_fav_item(id:Int)
    {
        let session = URLSession.shared
        let url = URL(string: "http://10.40.42.91:3000/add_fav_item?cus_id="+customer_ID+"&p_id="+String(id))!
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
    
    func get_product_item()
    {
        let session1 = URLSession.shared
        let url1 = URL(string: "http://10.40.42.91:3000/get_product_item?name="+name+"&id="+id)!
        print(url1)
        let task1 = session1.dataTask(with: url1) { (data1, _, _) -> Void in
            if let data1 = data1 {
                let string1 = String(data: data1, encoding: String.Encoding.utf8)
                //   print(string1) //JSONSerialization
                
                
                let json1 = try! JSONSerialization.jsonObject(with: data1, options: []) as? [[String:Any]]
                
                for dayData in json1!{
                    let areaObj = item2()
                    if let v0 = dayData["description"] as? String{
                        areaObj.desc = v0
                    }
                    if let v1 = dayData["image_url"] as? String{
                        areaObj.img = v1
                    }
                    if let v2 = dayData["price"] as? String{
                        areaObj.price = v2
                    }
                    if let v3 = dayData["p_id"] as? Int{
                        areaObj.id = v3
                    }
                    if let v4 = dayData["size"] as? String{
                        areaObj.size = v4
                    }
                    if let v5 = dayData["color"] as? String{
                        areaObj.color = v5
                    }
                    self.product.append(areaObj)
                }
            }
            var j=0;
            while (j<self.product.count)
            {
                self.desc_item = self.product[j].desc
                self.price_item = self.product[j].price
                self.img_url = self.product[j].img
                self.colors.append(self.product[j].color)
                self.sizes.append(self.product[j].size)
                self.p_ids.append(self.product[j].id)
                j=j+1
            }
            DispatchQueue.main.async {
                self.desc.text = self.desc_item
                self.price.text = self.price_item
                self.get_image(self.img_url, self.product_img)
                self.pickerView_size.reloadAllComponents()
                self.pickerView_color.reloadAllComponents()
            }
        }
        task1.resume()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btnPressed_size(_ sender: Any) {
        self.pickerView_size.isHidden = !self.pickerView_size.isHidden
    }
    
    @IBAction func btnPressed_color(_ sender: Any) {
        self.pickerView_color.isHidden = !self.pickerView_color.isHidden
        
    }
    
    @IBAction func heart_pressed(_ sender: Any) {
        if counter2 == 0
        {
            if color_id == size_id
            {
                self.heart_Label.setBackgroundImage(#imageLiteral(resourceName: "fave2"), for: .normal)
                counter2 = 1
                add_fav_item(id: p_ids[color_id!])
            }
            else
            {
                showToast(message: "Item Not Available")
            }
        }
        else
        {
            self.heart_Label.setBackgroundImage(#imageLiteral(resourceName: "heart"), for: .normal)
            delete_fav_item(id: p_ids[color_id!])
            counter2 = 0
        }
    }
    
    @IBAction func cart_pressed(_ sender: Any) {
        if counter1 == 0
        {
            if color_id == size_id
            {
                self.cart_Label.setBackgroundImage(#imageLiteral(resourceName: "bag2"), for: .normal)
                counter1 = 1
                add_cart_item(id: p_ids[color_id!])
            }
            else
            {
                showToast(message: "Item Not Available")
            }
        }
        else
        {
            self.cart_Label.setBackgroundImage(#imageLiteral(resourceName: "cart"), for: .normal)
            delete_cart_item(id: p_ids[color_id!])
            counter1 = 0
        }
    }
    
//    @IBAction func back_btn_pressed(_ sender: Any) {
//        self.performSegue(withIdentifier: "from_11_10", sender: nil)
//    }
    
    
}
