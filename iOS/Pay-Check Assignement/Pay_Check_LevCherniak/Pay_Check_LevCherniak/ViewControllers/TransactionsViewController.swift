//
//  TransactionsViewController.swift
//  Pay_Check_LevCherniak
//
//  Created by LeoChernyak on 04/06/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionsViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    var transactionsList: Results<Transaction>?
    
    var selectedProduct: Product? {
        didSet{
            readTransactions()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    
    
   

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        if let transaction = transactionsList?[indexPath.row]{
//            currencyConverter(transaction: transaction)
            cell.textLabel?.text = (selectedProduct?.name)! + " " + transaction.currency! + " " + String(transaction.amount) + " " + "GBP" + " " + String(transaction.amountGBP)
 
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return transactionsList?.count ?? 1
    }
    
    
    

    
    
    func readTransactions() {
        
        transactionsList = selectedProduct?.transactions.sorted(byKeyPath: "amount", ascending: true)
        
        self.tableView.reloadData()
    }
    
    
    func clearRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    
    

    

}
