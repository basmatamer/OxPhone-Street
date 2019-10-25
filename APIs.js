// TAKE CARE THAT TOKEN MUST BE SAVED IN SHARED PREFERENCES 
// ANY API SHOULD BE PASSED THIS TOKEN TO KNOW THE CUSTOMER DOING THIS OPERATION


// HWA EL MAFROOD N3ML F 7AGAT EL MANY-TO-MANY 7AGA ???????


var express = require("express");
var url = require("url");
var mysql = require("mysql");

var nodemailer = require("nodemailer");  // for sending an email 
var randomstring = require("randomstring");
var cloudinary = require('cloudinary');

//var mysqlUtilities = require('mysql-utilities');




cloudinary.config({ 
  cloud_name: 'dutrolzkl', 
  api_key: '179834633422515', 
  api_secret: 'ibnt7MH-E9wYcDSm95g83Vq2x9k' 
});


var app = express();
var mysqlcon = mysql.createConnection({
host: "localhost",
user: "root",
password: "",
database: "mobileappsproject"
//database : "project"
} );


var q;
var vcode;
mysqlcon.connect( function(err)
{
	if (err) throw err;
		console.log("Connected!");
});     


/*
// Mix-in for Data Access Methods and SQL Autogenerating Methods
mysqlUtilities.upgrade(mysqlcon);
// Mix-in for Introspection Methods
mysqlUtilities.introspection(mysqlcon);
*/


// Customer APIs 


/////////////////////////////////////
// When customer presses sign up 
app.get("/customer_signup", function (req, res) {
q = url.parse(req.url, true).query;     


vcode = randomstring.generate(6);  // generating random number for verification code 

var sql = "INSERT INTO customer (name, email, password, mobilenumber, address, verificationcode) VALUES (";    // I added image_url   

sql = sql + "'" + q.name + "'" + ", " + "'" + q.email + "'" + ", " + "'" + q.password + "'" + ", " + "'" + q.mobilenumber + 
				"'" + ", " + "'" + q.address + "'" +  "," /*+ "'" + q.image_url  + "'" + ","*/ + "'" + vcode + "'" + ")";   


console.log(vcode);


res.send(vcode);    

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;
		console.log("1 customer signed up");
	});

return vcode;

});

///////////////////////////////////////////////////////

app.get("/get_customerID", function (req, res){

q = url.parse(req.url, true).query;

var sql = "SELECT cu_id FROM customer WHERE name=";
sql = sql + "'" + q.customer_name + "'";


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;


	var a = JSON.stringify(result[0]);
	var h = JSON.parse(a);

	res.send(h.cu_id.toString());    // will make it return a JSON Object 
	console.log(h.cu_id.toString());
	console.log("Customer ID successfully retreived");

	});

});

//////////////////////////////////////////////////////


// API FOR inputting the verification code 

app.get("/verify", function (req, res) {
q = url.parse(req.url, true).query;     

var sql = "SELECT verificationcode FROM customer WHERE name = "
sql =sql +"'" + q.name + "'"; 

// Note that at this moment, the DB contains a real verificationcode, if the code below is executed sucessfully, the entry in DB should be replaced with NULL 
// so NULL is an indication of successful verification

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var v_status = "0";  // failure

	var a = JSON.stringify(result[0]);
	var h = JSON.parse(a);

	if(h.verificationcode === q.verificationcode){
		{
			console.log("Successful Verification");
			v_status = "1";

		}
	}
	res.send(v_status);
	console.log("Doneeee");
	console.log(v_status);
	});
});
/////////////////////////////////////////////////////////


// API that will be called after successfully verifying, to update the DB
app.get("/verify_updateDB", function (req, res) {
q = url.parse(req.url, true).query;     

var sql = "UPDATE customer SET verificationcode = NULL WHERE verificationcode = "  
sql = sql + "'" + q.verificationcode + "'";
sql = sql + "AND email = ";
sql = sql + "'" + q.email + "'";


mysqlcon.query(sql,
	function (err, result) {
		if (err) throw err;

	res.send(sql);
	console.log("Updated DB");

	});

});


///////////////////////////////////////////////

// Need a logic to assure that the username is unique !!!!!!

// API for logging in 
app.get("/login", function (req, res) {
q = url.parse(req.url, true).query; 


var sql = "SELECT password FROM customer WHERE (verificationcode IS NULL) AND (name = "
sql =sql + "'" + q.name + "')";

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var m_status = "1";  // success

	var a = JSON.stringify(result);
	if(a !== '[]')
	{
		var a = JSON.stringify(result[0]);
		var h = JSON.parse(a);

		console.log(h.password);

		if(h.password === q.password)
		{
				console.log("Successful login");
				m_status = "1";
		}


		else    // incompatible passwords 
		{
			console.log("UnnnnSuccessful login from inside");
			m_status = "0";
		}

	
	}	
	

	else   // username not found
	{
		console.log("UnnnnSuccessful login from outside");
		m_status = "0";
	}

	res.send(m_status);
	console.log(result);
	});	


});

/////////////////////////////////////////////////////

//////////////////////////////////////////////////////

// API to be called when forget password to get the email corresponding to the username 
// This assumes that usenames are unique and ofcourse emails should be unique (TYB WHAT IF SAME PERSON REGISTERS WITH 2 
																//DIFFERENT USERNAMES BUT SAME EMAIL ????)
// LH BYRAGA3 KOL EL EMAILS ????

app.get("/get_email_from_name", function (req, res) {
q = url.parse(req.url, true).query; 

var sql = "SELECT email FROM customer WHERE name =";
sql =sql + "'" + q.name + "'" ;

var my_return; 

mysqlcon.query(sql,
	function (err, result) {
		if (err) throw err;


		var a = JSON.stringify(result);
		if(a !== '[]')
		{
			var my_a = JSON.stringify(result[0]);
			var my_h = JSON.parse(my_a);

			my_return = my_h.email;

		}

		else
		{
			my_return = "NULL";
		}
		
	res.send(my_return);
	console.log("Retreived email");

	});

});


/////////////////////////////////////////////////

/*
app.get("/get_password_from_name", function (req, res) {
q = url.parse(req.url, true).query; 

var sql = "SELECT password FROM customer WHERE name =";
sql =sql + "'" + q.name + "'" ; 
sql = sql + "AND email =";
sql = sql + "'" + q.email + "'";

mysqlcon.query(sql,
	function (err, result) {
		if (err) throw err;

		var a = JSON.stringify(result[0]);
		var h = JSON.parse(a);

	res.send(h.password);
	console.log("Retreived password");

	});

});
*/

///////////////////////////////////////////////////

// API for uploading image  (takes image path and returns URL)

app.get("/uploadImage", function (req, res) {
q = url.parse(req.url, true).query; 


cloudinary.uploader.upload(q.path, function(result) {

	var a = JSON.stringify(result);
	var h = JSON.parse(a);

	res.send(h.url);
  console.log(h.url) 
});

// Need to save the URLs in Database in 3 places (1. Customer Profile Picture   2. Product image  3. Shop image )

});

///////////////////////////////////////

app.get("/edit_profile", function (req, res) {    
q = url.parse(req.url, true).query; 


var sql = "UPDATE customer SET name=";
sql = sql + "'" + q.newname + "'" + ", email=";
sql = sql + "'" + q.email + "'" + ", password=";
sql = sql + "'" + q.password + "'" + ", mobilenumber=";
sql = sql + "'" + q.mobilenumber + "'" + ",address=";
sql = sql + "'" + q.address + "'";
sql = sql + " WHERE cu_id =" + "'" + q.customer_ID + "'";



    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(result);
        res.send(sql);
        console.log("sucessfully edited the profile");
	});

});


///////////////////////////////////////////////////////////////////////////////////////

app.get("/update_image", function (req, res) {    
q = url.parse(req.url, true).query; 


var sql = "UPDATE customer SET image_url=";
sql = sql + "'" + q.url + "'";
sql = sql + " WHERE cu_id =" + "'" + q.customer_ID + "'";

    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(result);
        res.send(sql);
        console.log("sucessfully updated the profile picture");
	});

});

///////////////////////////////////////////////////

app.get("/get_profile_info", function (req, res) {    
q = url.parse(req.url, true).query; 


var sql = "SELECT * FROM customer WHERE cu_id=" + "'"  + q.customer_ID + "'";


    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(result[0]);
        res.send(result[0]);
        console.log("sucessfully retreived profile info");
	});

});

/////////////////////////////////////////////////

app.get("/add_preferred_categories", function (req, res) {    // NEW FOR ADDING CATEGORIES TO CUSTOMER
q = url.parse(req.url, true).query; 


var sql = "INSERT INTO customer_category_manytomany (RelationCustomerID, RelationCategoryID) VALUES (";
sql = sql + "'" + q.customer_id + "'" + "," + "'" + q.category_id + "'" + ")";

    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(sql);
        res.send(sql);
        console.log("successfully added customer's preferred categories");
	});

});

//////////////////////////////////////////////////

app.get("/delete_preferred_categories", function (req, res) {    // NEW FOR ADDING CATEGORIES TO CUSTOMER
q = url.parse(req.url, true).query; 


var sql = "DELETE FROM customer_category_manytomany WHERE RelationCustomerID=" + "'" + q.customer_id + "'" ;
sql = sql + "AND RelationCategoryID=" + "'" + q.category_id + "'";


    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(sql);
        res.send(sql);
        console.log("successfully deleted categories from customer");
	});

});

//////////////////////////////////////////////

app.get("/get_preferred_categories", function (req, res) {    
q = url.parse(req.url, true).query; 


var sql = "SELECT * FROM customer_category_manytomany WHERE RelationCustomerID=" + "'" + q.customer_id + "'" ;

    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

	   var a = JSON.stringify(result);
		var h = JSON.parse(a);

        console.log(h);
        res.send(h);
        console.log("successfully retreived categories from customer");
	});

});

/////////////////////////////////////////////////

app.get("/update_wallet", function (req, res) {    // API that takes the updated credit of that user according to a token and inserts it in DB
q = url.parse(req.url, true).query; 

var sql = "UPDATE customer SET cu_wallet = ";
sql = sql + "'" + q.credit + "'";
sql = sql + "WHERE cu_id = (SELECT cus_id FROM token WHERE token_value =" ;  
sql =sql + "'" + q.token + "'" + ")" ;

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(sql);
	console.log("sucessfully updated wallet");
	});

});



////////////////////////////////////////////////////
app.get("/retreive_wallet", function (req, res) {    // API that takes the updated credit of that user according to a token and inserts it in DB
q = url.parse(req.url, true).query; 

var sql = "SELECT cu_wallet FROM customer WHERE cu_id = (SELECT cus_id FROM token WHERE token_value =" ;  
sql =sql + "'" + q.token + "'" + ")" ;


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;


	var a = JSON.stringify(result[0]);
	var h = JSON.parse(a);

	res.send(h.cu_wallet.toString());
	console.log("sucessfully retreived wallet");
	});

});


//////////////////////////////////////////////  NEWLY ADDED APIs

app.get("/admin_signup", function (req, res) {
q = url.parse(req.url, true).query;     


vcode = randomstring.generate(6);  // generating random number for verification code 

var sql = "INSERT INTO shopAdmin (name, email, password, mobilenumber, verificationcode) VALUES (";    


sql = sql + "'" + q.name + "'" + ", " + "'" + q.email + "'" + ", " + "'" + q.password + "'" + ", " + "'" + q.mobilenumber + 
				"'" + ", " + "'" + vcode + "'" + ")";    


console.log(vcode);


res.send(vcode);    
mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;
		console.log("1 Shop Admin signed up");
	});
});

///////////////////////////////////////////////////

// API to return the shopAdmin ID, will be called after successful sign up and verification to save the ID in shared preferences

app.get("/get_AdminID", function (req, res){

q = url.parse(req.url, true).query;

var sql = "SELECT sa_id FROM shopAdmin WHERE name=";
sql = sql + "'" + q.admin_name + "'";


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;


	var a = JSON.stringify(result[0]);
	var h = JSON.parse(a);

	res.send(h.sa_id.toString());    // will make it return a JSON Object 
	console.log(h.sa_id.toString());
	console.log("Shop Admin ID successfully retreived");

	});

});



///////////////////////////////////////////////////

// API FOR inputting the verification code 

app.get("/admin_verify", function (req, res) {
q = url.parse(req.url, true).query;     

var sql = "SELECT verificationcode FROM shopAdmin WHERE name = "
sql =sql +"'" + q.name + "'"; 

// Note that at this moment, the DB contains a real verificationcode, if the code below is executed sucessfully, the entry in DB should be replaced with NULL 
// so NULL is an indication of successful verification

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var v_status = "0";  // failure

	var a = JSON.stringify(result[0]);
	var h = JSON.parse(a);

	if(h.verificationcode === q.verificationcode){
		{
			console.log("Successful Verification");
			v_status = "1";

		}
	}
	res.send(v_status);
	console.log("Doneeee");
	console.log(v_status);
	});
});
/////////////////////////////////////////////////////////


// API that will be called after successfully verifying, to update the DB
app.get("/admin_verify_updateDB", function (req, res) {
q = url.parse(req.url, true).query;     

var sql = "UPDATE shopAdmin SET verificationcode = NULL WHERE verificationcode = "  
sql = sql + "'" + q.verificationcode + "'";
sql = sql + "AND email = ";
sql = sql + "'" + q.email + "'";


mysqlcon.query(sql,
	function (err, result) {
		if (err) throw err;

	res.send(sql);
	console.log("Updated DB");

	});

});


///////////////////////////////////////////////


////////////////////////////////////////////////////

// CHECK HOW TO PLACE SHOPADMIN ID ?????? BASED ON EH WE DO IT IN 1-TO-MANY RELATIONSHIPS ?????


// API for service provider to add a new shop      // INPUT UR MAIL!!!!!
app.get("/add_shop", function (req, res) {
q = url.parse(req.url, true).query;     


var sql = "INSERT INTO shop (name, landline, address, s_admin_id) VALUES (";
sql = sql + "'" + q.name + "'" + "," + "'" + q.landline + "'" + "," + "'" + q.address + "'" + "," + "'" + q.admin_ID + "')";

// CHANGE 7WAR EL EMAIL DA TO THE UNIQUE ID SAVED IN SHARED PREFERENCES 


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(sql);

	console.log("sucessfully Added a new shop");
	});

});


////////////////////////////////////////////////////

app.get("/add_shop_category", function (req, res) {
q = url.parse(req.url, true).query;     



var sql = "INSERT INTO category_shop_manytomany (RelationCa_ID, RelationshopID) VALUES (";
sql = sql + "'" + q.category_id + "'" + "," + "(SELECT s_id FROM shop WHERE name=" + "'" + q.shop_name + "'))";				// + "," + "'" + q.shop_id + "')";

// CHANGE 7WAR EL EMAIL DA TO THE UNIQUE ID SAVED IN SHARED PREFERENCES 


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(sql);

	console.log("sucessfully Added a shop and its category");
	});

});

//////////////////////////////////////////////////////

app.get("/retreive_shop_id", function (req, res) {     // Wait till the shop is actually added in shop table then retreive its ID
q = url.parse(req.url, true).query;     


var sql = "SELECT s_id FROM shop WHERE name=" + "'" + q.name + "'";
sql = sql + "AND s_admin_id=" + "'"  + q.shopAdmin_ID + "'";


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var a = JSON.stringify(result[0]);
	var h = JSON.parse(a);

	res.send(JSON.stringify(h.s_id));

	console.log("sucessfully retreived the ID of shop you're adding");
	});

});

////////////////////////////// Retrieve product_id : needed in the process of uploading image to the product

app.get("/retreive_p_id", function (req, res) {     // Wait till the shop is actually added in shop table then retreive its ID
q = url.parse(req.url, true).query;     


var sql = "SELECT p_id FROM product WHERE name=" + "'" + q.name + "'";
sql = sql + "AND color=" + "'"  + q.color + "'" + "AND size=" + "'" + q.size + "'";


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var a = JSON.stringify(result[0]);
	var h = JSON.parse(a);

	res.send(JSON.stringify(h.p_id));

	console.log("sucessfully retreived the ID of shop you're adding");
	});

});


///////////////////////////////////////////////////////////////////////////////////////

app.get("/update_shop_image", function (req, res) {    
q = url.parse(req.url, true).query; 


var sql = "UPDATE shop SET image_url=";
sql = sql + "'" + q.url + "'";
sql = sql + " WHERE name =" + "'" + q.name + "'" + "AND s_admin_id=" + "'" + q.shopAdmin_ID + "'";

    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(result);
        res.send(sql);
        console.log("sucessfully updated the shop image");
	});

});


//////////////////////////////////////////////////

app.get("/update_product_image", function (req, res) {    
q = url.parse(req.url, true).query; 


var sql = "UPDATE product SET image_url=";
sql = sql + "'" + q.url + "'";
sql = sql + " WHERE p_id =" + "'" + q.p_id + "'";

    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(result);
        res.send(sql);
        console.log("sucessfully updated the shop image");
	});

});



/////////////////////////////////////////////////////

// IN THIS API WE ASSUME THAT ALL SHOPS HAVE UNIQUE NAMES !! NEED TO FIGURE OUT HOW TO MAKE SURE OF THIS ???????

// API for service provider to add a new item in a shop      

app.get("/add_newproduct", function (req, res) {   // must specify the shop you will add the product to 
q = url.parse(req.url, true).query;     

var sql = "INSERT INTO product (name, price, availability, numberinstock, color, size, description, category_id, shop_id) VALUES (";
sql = sql + "'" + q.name + "'" + "," + "'" + q.price + "'" + "," + "'" + q.availability + "'" + "," + "'" + q.numberinstock + "'" + "," ;
sql = sql + "'" + q.color + "'" + "," + "'" + q.size + "'" + "," +  "'"  + q.description + "'" +  ",";
sql = sql + "(SELECT ca_id FROM categories WHERE name = " + "'" + q.category_name + "'" + ")" + "," ;
sql = sql + "(SELECT s_id FROM shop WHERE name = " + "'" + q.shop_name + "'" + "))";



mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(sql);

	console.log("Sucessfully Added a new product");
	});

});

// STILL NEEDS IMAGE_URL



////////////////////////////////////////////////////

// API for inserting a new category 
app.get("/add_newcategory", function (req, res) {   
q = url.parse(req.url, true).query;     

var sql = "INSERT INTO categories(name) VALUES (";
sql = sql + "'" + q.name + "'" + ")";


mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(sql);

	console.log("Sucessfully Added a new category");
	});

});


//////////////////////////////////////////////////

// IN THIS API WE ASSUME THAT ALL PRODUCTS HAVE UNIQUE NAMES !! NEED TO FIGURE OUT HOW TO MAKE SURE OF THIS ???????

// I ASSUME THAT HE CAN'T EDIT THE SHOP THAT THIS PRODUCT BELONGS TO NOR THE CATEGORY IT BELONGS TO 

// API for service provider to edit item in a shop 

// 



//////////////////////////////////////////////////////
app.get("/get_shops_details", function (req, res) {       // NEED TO GET THE DETAILS OF ALL THE SHOPS 
q = url.parse(req.url, true).query;     

var sql = "SELECT * FROM shop WHERE s_admin_id = " + "'"  + q.adminID + "'" ; 

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	
//JSON.stringify(result)
	//var a = JSON.stringify(result[0]);
    //var h = JSON.parse(a);

    res.send(result);
	console.log(result);    // returns array of JSON objects 


	console.log("Sucessfully retreived all Shops of this Admin");
	});

});

/////////////////////////////////////////////////// To get the details of the products of a specific shop

app.get("/get_products_details", function (req, res) {       // NEED TO GET THE DETAILS OF ALL THE SHOPS 
q = url.parse(req.url, true).query;     

var sql = "SELECT * FROM product WHERE shop_id = " 
sql = sql + "(SELECT s_id FROM shop WHERE name="+  "'"  + q.shop_name + "')" ; 

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	
    res.send(result);
	console.log(result);    // returns array of JSON objects 


	console.log("Sucessfully retreived all products in this shop");
	});

});

///////////////////////////////////////////////////// New API to return all shop names in a specific category

app.get("/get_shops_of_chosen_category", function (req, res) {     // returns IDs of shops 
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT RelationshopID FROM category_shop_manytomany WHERE RelationCa_ID =" + q.cat_id;
    
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        
        res.send(result);
        console.log("Successfully retreived all shops of this category");
        console.log(result);
        });
    
});

///////////////////////////////////////////////////////

app.get("/get_shop_name_of_chosen_category", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT name FROM shop WHERE s_id =" + q.s_id;
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        
	   	var a = JSON.stringify(result[0]);
		var h = JSON.parse(a);

        res.send(h.name);
        console.log("sucessfully connected to get_shop");
        console.log(h.name);
        });
    
});


////////////////////////////////////////////////////

app.get("/get_shop_category", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT RelationCa_ID FROM category_shop_manytomany WHERE RelationshopID =";
    sql = sql + "(SELECT s_id FROM shop WHERE name =" + "'" + q.shop_name + "'" + "AND s_admin_id=" + "'" + q.shopAdmin_ID + "')";

    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        
	  var a = JSON.stringify(result[0]);
	  var h = JSON.parse(a);

        res.send(JSON.stringify(h.RelationCa_ID));
        console.log("sucessfully retreived shop category");
        console.log(JSON.stringify(h.RelationCa_ID));
        });
    
});

/////////////////////////////////////////////////////

app.get("/get_product_category", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT RelationCa_ID FROM category_shop_manytomany WHERE RelationshopID =";
    sql = sql + "(SELECT shop_id FROM product WHERE name=" + "'" + q.name + "'" + "AND color=" + "'" + q.color + "'" + "AND size=" + "'" + q.size  + "'" + ")";

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        
	  var a = JSON.stringify(result[0]);
	  var h = JSON.parse(a);

        res.send(JSON.stringify(h.RelationCa_ID));
        console.log("sucessfully retreived product category");
        console.log(JSON.stringify(h.RelationCa_ID));
        });
    
});


////////////////////////////////////////////////////

// API for service provider to delete a shop 

app.get("/delete_shop", function (req, res) {  
q = url.parse(req.url, true).query;     


sql = "DELETE FROM shop WHERE name = " + "'" + q.shop_name + "'" + "AND s_admin_id=" + "'" + q.shopAdmin_ID + "'";

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(sql);

	console.log("Sucessfully Deleted a shop");
	});

});


/////////////////////////////////////////////

// API for service provider to delete a product from a shop 

app.get("/delete_product", function (req, res) {   // must specify the shop you will delete the product from 
q = url.parse(req.url, true).query;     


sql = "DELETE FROM product WHERE name = " + "'" + q.product_name + "'" ;

mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(sql);

	console.log("Sucessfully Deleted a product");
	});

});

////////////////////////////////////////////////////////////////////////

app.get("/get_products_name_from_ID", function (req, res) {   // must specify the shop you will delete the product from 
q = url.parse(req.url, true).query;     


//sql = "SELECT name FROM product WHERE p_id = (SELECT cart_p_id FROM cart WHERE shopAdmin_ID =";
//sql = sql + "'" + q.shopAdmin_ID + "'" + ")";

var sql = "SELECT name FROM product WHERE p_id=" + "'" + q.product_ID + "'";
mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var a = JSON.stringify(result[0]);
	var b = JSON.parse(a);

	res.send(b.name);
	console.log(b.name);

	console.log("Sucessfully retreived product name from ID");
	});

});



//////////////////////////////////////////////////////////////////
// To let the service Provider see the requested orders
app.get("/get_admin_products", function (req, res) {   // must specify the shop you will delete the product from 
q = url.parse(req.url, true).query;     


var sql = "SELECT cart_p_id FROM cart WHERE shopAdmin_ID=" + "'" + q.shopAdmin_ID + "'";



mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(result);
	console.log(result);

	console.log("Sucessfully retreived all product IDs of that shop admin");
	});

});

//////////////////////////////////////////////////////////////

app.get("/add_fav_shop", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "INSERT IGNORE INTO favorite_shops (favorites_cus_id, favorites_s_id) VALUES ("
    sql = sql + q.cus_id +","+ q.s_id+")";
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to add_fav_shop");
        console.log(result);
        });
});

app.get("/delete_fav_shop", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "DELETE FROM favorite_shops WHERE favorites_cus_id =";
    sql = sql + q.cus_id +" AND favorites_s_id ="+ q.s_id;
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to delete_fav_shop");
        console.log(result);
        });
});


app.get("/get_admin_customers", function (req, res) {   // must specify the shop you will delete the product from 
q = url.parse(req.url, true).query;     


var sql = "SELECT cart_cu_id FROM cart WHERE shopAdmin_ID=" + "'" + q.shopAdmin_ID + "'" + "AND cart_p_id=" + "'" + q.cart_p_id  + "'";



mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	res.send(result);
	console.log(result);

	console.log("Sucessfully retreived all customer IDs of that shop admin");
	});

});


//////////////////////////////////////////////////////////////////

app.get("/get_customer_name_from_ID", function (req, res) {   // must specify the shop you will delete the product from 
q = url.parse(req.url, true).query;     


//sql = "SELECT name FROM product WHERE p_id = (SELECT cart_p_id FROM cart WHERE shopAdmin_ID =";
//sql = sql + "'" + q.shopAdmin_ID + "'" + ")";

var sql = "SELECT name FROM customer WHERE cu_id=" + "'" + q.customer_ID + "'";
mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var a = JSON.stringify(result[0]);
	var b = JSON.parse(a);

	res.send(b.name);
	console.log(b.name);

	console.log("Sucessfully retreived customer name from ID");
	});

});

///////////////////////////////////////////////////////////////

app.get("/order_get_shop_name", function (req, res) {   // must specify the shop you will delete the product from 
q = url.parse(req.url, true).query;     


//sql = "SELECT name FROM product WHERE p_id = (SELECT cart_p_id FROM cart WHERE shopAdmin_ID =";
//sql = sql + "'" + q.shopAdmin_ID + "'" + ")";

var sql = "SELECT name FROM shop WHERE s_id= (SELECT shop_id FROM product WHERE p_id=" + "'" + q.cart_p_id + "')";
mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var a = JSON.stringify(result[0]);
	var b = JSON.parse(a);

	res.send(b.name);
	console.log(b.name);

	console.log("Sucessfully retreived customer name from ID");
	});

});

//////////////////////////////////////////////////////////////////

app.get("/get_shopName_from_product_name", function (req, res) {   
q = url.parse(req.url, true).query;     


//sql = "SELECT name FROM product WHERE p_id = (SELECT cart_p_id FROM cart WHERE shopAdmin_ID =";
//sql = sql + "'" + q.shopAdmin_ID + "'" + ")";

var sql = "SELECT name FROM shop WHERE s_id= (SELECT shop_id FROM product WHERE name=" + "'" + q.name + "'" ; 
sql = sql + "AND color=" + "'" + q.color + "'" + "AND size=" + "'"  + q.size + "')";
mysqlcon.query(sql,
function (err, result) {
	if (err) throw err;

	var a = JSON.stringify(result[0]);
	var b = JSON.parse(a);

	res.send(b.name);
	console.log(b.name);

	console.log("Sucessfully retreived shop name from customer name");
	});

});





//////////////////////////////////////////////////////////////////////// NEW APIs  (HABIBAA'SS)

app.get("/get_categories", function (req, res) {    // API that loads data into the explore page

    q = url.parse(req.url, true).query; 
    var sql = "Select RelationCategoryID FROM customer_category_manytomany WHERE RelationCustomerID =" + "'" + q.customer_ID + "'";


    // HABIBAA'SS
    //  (SELECT cu_id FROM customer WHERE name =" 
    // sql = sql + "'" + q.name + "')" ;




    //console.log(sql);
    //var sql = "SELECT RelationshopID FROM category_shop_manytomany WHERE RelationCa_ID = (" + sql1+") Order by RAND() LIMIT 3"
    //now I have all the category ids of interest in an array
    //now I should get 3 shops in each category to be in explore (3 is negotiable)

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        /*var i;
        var a = JSON.stringify(result);
        var h = JSON.parse(a);
        
        console.log("h is");
        console.log(h);
        for(i = 0; i < result.length; i++)
        {
            sql = "SELECT RelationshopID FROM category_shop_manytomany WHERE RelationCa_ID =" + h[i].RelationCategoryID;
            sql = sql + " ORDER BY RAND() LIMIT 3";
            
        mysqlcon.query(sql,
		function (err, result2) {
			if (err) throw err;
				console.log("GOT URL");
            //result = mergeJSON.merge(result[0],result2);
            console.log("result2 is:", JSON.stringify(result2));
            var j;
            for(j=0; j<result2.length;j++)
                {
                    all[i+j] = JSON.parse(JSON.stringify(result2[j])).RelationshopID;
                    
                }
			});	
            console.log(result2);
            res.send(result2);
        }*/
    
        var a = JSON.stringify(result);
        var h = JSON.parse(a);
        //console.log(sql);
        //console.log("Result's length is",result.length);
        res.send(result);
        console.log("sucessfully connected to get_categories");
        console.log(result);
        //console.log("all is", all);
	});
    

});

app.get("/get_shops_cateory", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT RelationshopID FROM category_shop_manytomany WHERE RelationCa_ID =" + q.cat_id;
    sql = sql + " ORDER BY RAND() LIMIT 3";
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        
        
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_shops_categoty");
        console.log(result);
        });
    
});

app.get("/get_shop_images", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 

    var sql = "SELECT image_url FROM product where shop_id = (SELECT s_id FROM shop WHERE name ="
    sql = sql + "'" + q.name+ "') LIMIT 3";
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        var a = JSON.stringify(result);
        var result2;
        //var h = JSON.parse(a);
        if(a !== '[]')
            {
                
                result2 = result;
            }
        else
            {
                result2 = [ {
                                "image_url": "NULL"
                            }, 
                           {
                                "image_url": "NULL"
                            }, 
                           {
                                "image_url": "NULL"
                            }
                          ];
            }
        res.send(result2);       
        console.log("sucessfully connected to get_shop_images");
        console.log(result);
	});

});

app.get("/get_shop", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT * FROM shop WHERE s_id =" + q.s_id;
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        
        
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_shop");
        console.log(result);
        });
    
});

//////////////////////////////////////////////////////////////

app.get("/get_product_categories", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 
       
    //var sql = "SELECT * FROM product WHERE category_id = (SELECT ca_id FROM categories WHERE name =";
    //sql = sql + "'" + q.name +"') ORDER BY p_id LIMIT 4";
    
    var sql = "SELECT * FROM product WHERE category_id = ";
    sql = sql + q.id +" ORDER BY p_id LIMIT 4";
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_product_categories");
        console.log(result);
        });
    
});

/////////////////////////////////////////////////////////////////


/*
app.get("/explore", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 

    var sql = "SELECT * FROM shop WHERE name = " ;  
    sql = sql + "'" + q.name + "'" ;


    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
    
        /*sql = "SELECT  image_url FROM product where shop_id = (SELECT id FROM shop WHERE name ="
        sql = "'" + q.name+ "') LIMIT 3";

        mysqlcon.query(sql,
		function (err, result2) {
			if (err) throw err;
				console.log("GOT URL");
            result = mergeJSON.merge(result[0],result2);
			});	
    
    
        //var a = JSON.stringify(result[0]);
        //var h = JSON.parse(a);
        console.log(result);
        res.send(result);
        console.log("sucessfully retreived data for explore");
	});

});




app.get("/get_shop_images", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 

    var sql = "SELECT image_url FROM product where shop_id = (SELECT s_id FROM shop WHERE name ="
    sql = sql + "'" + q.name+ "') LIMIT 3";

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result[0]);
        //var h = JSON.parse(a);
        console.log(result);
        res.send(result);
        console.log("sucessfully got images");
	});

});

app.get("/get_shop_products", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 

    var sql = "SELECT * FROM product WHERE shop_id = (SELECT s_id FROM shop WHERE name =" 
    sql = sql +"'"+ q.name+ "')";

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result[0]);
        //var h = JSON.parse(a);
        console.log(result);
        res.send(result);
        console.log("sucessfully got shop's products");
	});

});


app.get("/get_product_info", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 

    var sql = "SELECT * FROM product WHERE name = "
    sql = "'" + q.product_name+ "' AND shop_id = (SELECT id FROM shop WHERE name =" 
    sql = sql +"'"+ q.shop_name+ "')";

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;0
        console.log(result);
        res.send(result);
        console.log("sucessfully got producct info");
	});

});

*/

//////////////////////////////////////////////////////////

app.get("/update_password", function (req, res) {    
q = url.parse(req.url, true).query; 

    var sql = "UPDATE customer SET password = "
    sql = sql + "'" + q.password+ "'";
    sql = sql + "WHERE name=" + "'" + q.name + "'";
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(result);
        res.send(sql);
        console.log("sucessfully updated the password");
	});

});

//////////////////////////////////////////////////////////////

app.get("/get_fav_shops", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT favorites_s_id FROM favorite_shops WHERE favorites_cus_id ="
    sql = sql + q.cus_id;
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_fav_shops");
        console.log(result);
        });
    
});

////////////////////////////////////History////////////////////////////////////////////////////
app.get("/get_history", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT * FROM history WHERE history_cu_id = "
    sql = sql + q.cus_id;
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_fav_shops");
        console.log(result);
        });
});

app.get("/get_product_history", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT * FROM product WHERE p_id = "
    sql = sql + q.p_id;

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_fav_shops");
        console.log(result);
        });
});

//////////////////////////////cart////////////////////////////////////////////////////////////////
app.get("/get_cart", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT cart_p_id FROM cart WHERE cart_cu_id = "
    sql = sql + q.cus_id;
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_cart");
        console.log(result);
        });
});

app.get("/checkout", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "INSERT INTO history (history_cu_id, history_p_id, amount_paid) VALUES ("
    sql = sql + q.cus_id + ","+ q.p_id +","+ q.price+")";
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to checkout");
        console.log(result);
        });
});

//////////////////////////////product item/////////////////////////////////////////////////////////
app.get("/get_product_item", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT * FROM product WHERE name = "
    sql = sql + "'" + q.name + "' AND shop_id = '"+ q.id+"'";
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        res.send(result);
        console.log("sucessfully connected to checkout");
        console.log(result);
        });
});

app.get("/add_fav_item", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "INSERT IGNORE INTO favorite_products (favorites_cu_id, favorites_p_id) VALUES ("
    sql = sql + q.cus_id +","+ q.p_id+")";
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to checkout");
        console.log(result);
        });
});

app.get("/delete_fav_item", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "DELETE FROM favorite_products WHERE favorites_cu_id =";
    sql = sql + q.cus_id +" AND favorites_p_id ="+ q.p_id;
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to checkout");
        console.log(result);
        });
});

app.get("/add_cart_item", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    // var sql = "INSERT INTO cart (cart_cu_id, cart_p_id, shopAdmin_ID) VALUES ("
    // sql = sql + q.cus_id +","+ q.p_id+","+ q.sa_id+")";

    var sql = "INSERT IGNORE INTO cart (cart_cu_id, cart_p_id, shopAdmin_ID) VALUES ("
    sql = sql + "(SELECT cu_id FROM customer WHERE cu_id=" + "'" + q.cus_id + "')" + ", (SELECT p_id from product WHERE p_id=" +  "'" + q.p_id + "')" 
    sql = sql + ", (SELECT sa_id FROM shopadmin WHERE sa_id=" + "'" + q.sa_id + "'" + "))"

    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to checkout");
        console.log(result);
        });
});


app.get("/delete_cart_item", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "DELETE FROM cart WHERE cart_cu_id =";
    sql = sql + q.cus_id +" AND cart_p_id ="+ q.p_id+" AND shopAdmin_ID ="+ q.sa_id;
    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to checkout");
        console.log(result);
        });
});

/////////////////////////////////////display shop/////////////////////////////////////////////
app.get("/get_shop_products", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 

    var sql = "SELECT * FROM product WHERE shop_id =" 
    sql = sql +"'"+ q.shop_id+ "'";

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;0
        console.log(result);
        res.send(result);
        console.log("sucessfully get_shop_products");
	});

});
//////////////////////////////////////////favorite items/////////////////////////////////////////////
app.get("/get_fav_products", function (req, res) {    // API that loads data into the fav page
q = url.parse(req.url, true).query; 
       
    var sql = "SELECT favorites_p_id FROM favorite_products WHERE favorites_cu_id ="
    sql = sql + q.cus_id;
    //console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;
        //var a = JSON.stringify(result);
        //var h = JSON.parse(a);
        //console.log(sql);
        //console.log(a);
        res.send(result);
        console.log("sucessfully connected to get_fav_products");
        console.log(result);
        });
    
});

app.get("/get_product_info", function (req, res) {    // API that loads data into the explore page
q = url.parse(req.url, true).query; 

    var sql = "SELECT * FROM product WHERE p_id = "
    sql = sql + q.p_id; 

    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;0
        console.log(result);
        res.send(result[0]);
        console.log("sucessfully got producct info");
	});

});


///////////////////////////////categories choosing//////////////////////////////////
app.get("/add_preferred_categories", function (req, res) {    // NEW FOR ADDING CATEGORIES TO CUSTOMER
q = url.parse(req.url, true).query; 


var sql = "INSERT IGNORE INTO customer_category_manytomany (RelationCustomerID, RelationCategoryID) VALUES (";
sql = sql + "'" + q.customer_id + "'" + "," + "'" + q.category_id + "'" + ")";

    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(sql);
        res.send(sql);
        console.log("sucessfully added customer's preferred categories");
	});

});

app.get("/delete_preferred_categories", function (req, res) {    // NEW FOR ADDING CATEGORIES TO CUSTOMER
q = url.parse(req.url, true).query; 


var sql = "DELETE FROM customer_category_manytomany WHERE RelationCustomerID=" + "'" + q.customer_id + "'" ;
sql = sql + "AND RelationCategoryID=" + "'" + q.category_id + "'";


    console.log(sql);
    mysqlcon.query(sql,
    function (err, result) {
	   if (err) throw err;

        console.log(sql);
        res.send(sql);
        console.log("sucessfully deleted categories from customer");
	});

});

/////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////

// app.get("/order_notify_admin", function (req, res) {        // Called inside customer's app once he confirms payment 
// q = url.parse(req.url, true).query; 


// var sql = "SELECT s_admin_id FROM shop WHERE s_id= (SELECT shop_id from product WHERE p_id="+ "'" + q.cart_p_id + "')"


//     console.log(sql);
//     mysqlcon.query(sql,
//     function (err, result) {
// 	   if (err) throw err;

// 	    var a = JSON.stringify(result[0]);
//         var h = JSON.parse(a);
      

//         console.log(JSON.stringify(h.s_admin_id));
//         res.send(JSON.stringify(h.s_admin_id));
//         console.log("successfully retreived the shop admin ID");
// 	});

// });


//////////////////////////////////////////////////////////////////////////////////////////

app.listen(3000, function() {
	console.log("Example app listening on port 3000!");
}



);


