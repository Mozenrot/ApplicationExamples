//
//  ProductsViewController.swift
//  Pay_Check_LevCherniak
//
//  Created by LeoChernyak on 04/06/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit
import RealmSwift

class ProductsViewController: UITableViewController {
    
    let realm = try! Realm()
    var productsList : Results<Product>?
    
    var json: [[String:Any]]?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let path = Bundle.main.path(forResource: "transactions1", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe) as Data
        json = try! JSONSerialization.jsonObject(with: jsonData!, options: []) as? [[String:Any]]
        
        clearRealm()
        getProductData()
        readProductsList()
        
    }
    
    
    
    // MARK: - Parsing JSON Files
    func getProductData() {
        
        for transaction in json!{
            
            let productObject = Product()
            
            
            if let productName = transaction["sku"] as? String{
                productObject.name = productName
                productObject.id = productName
                getTransactionsData(product: productObject)
                
            }
            
            save(product: productObject)
            
            
        
        }
        
    }
    
    func getTransactionsData(product: Product){
        
                for transaction in json!{
                    if product.name == transaction["sku"] as? String{
                        let transactionObject = Transaction()
                        
                        if let sku = transaction["sku"] as? String{
                            transactionObject.sku = sku
                        }
                        
                        if let currency = transaction["currency"] as? String{
                            transactionObject.currency = currency
                        }
                        
                        if let amount = transaction["amount"] as? String{
                            transactionObject.amount = Double(amount)!
                        }
                        
                        if transactionObject.currency == "GBP"{
                            transactionObject.currencyGBP = "GBP"
                            transactionObject.amountGBP = transactionObject.amount
                        } else {
                            currencyConverter(transactioObject: transactionObject)
                        }
                        
                        
                        product.transactions.append(transactionObject)
                        
                        
                    }
                    
                }
    }
    
    
    
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cellText = "Product = \(productsList?[indexPath.row].name ?? "There are no Products yet"). Num of transactions  \(productsList?[indexPath.row].transactions.count ?? 0)"
        
        
        
        
        cell.textLabel?.text = cellText
        
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 4
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTransactions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TransactionsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedProduct = productsList?[indexPath.row]
        }
        
    }

    

   
    
    
    
    
    //MARK: - Realm Functions
    
    func save(product: Product) {
        do {
            try realm.write {
                
                realm.add(product, update: true)
            }
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    
    
    func readProductsList() {
        
        productsList = realm.objects(Product.self)
        
        self.tableView.reloadData()
    }
    
    
    
    
    func clearRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    
    func currencyConverter(transactioObject: Transaction) {
        
        let path = Bundle.main.path(forResource: "rates2", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe) as Data
        let jsonRates = try! JSONSerialization.jsonObject(with: jsonData!, options: []) as? [[String:Any]]
        
        var from_cur = ""
        var to_cur = ""
        var help_var = transactioObject.currency
        var value_cur = transactioObject.amount
        var rate_cur = 0.0
        
        
        repeat{
        
        for rate in jsonRates!{
            
            if let rateFrom = rate["from"] as? String{
                from_cur = rateFrom
            }
            if let rate = rate["rate"] as? String{
                rate_cur = Double(rate) ?? 1
            }
            
            if let to = rate["to"] as? String{
                to_cur = to
            }
            
            if from_cur == "GBP" {
                
                transactioObject.currencyGBP = to_cur
                transactioObject.amountGBP = value_cur
                
            }
            
            if help_var == from_cur{
                value_cur = value_cur * rate_cur
                
                print(transactioObject.amount)
                print(rate_cur)
                help_var = to_cur
            }
            
            
            
            
            
        }
        
        } while transactioObject.currencyGBP == "GBP"
        
    }
    

}
