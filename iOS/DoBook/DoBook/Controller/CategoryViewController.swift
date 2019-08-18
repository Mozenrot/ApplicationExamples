//
//  CategoryViewController.swift
//  DoBook
//
//  Created by LeoChernyak on 16/04/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    
    var listCategory: Results<Category>?
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        readCategory()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
       
        
        updateUIViewMode()
        

    }
    

    
    //MARK: SwipeCellKit Delegate Methods
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        cell.textLabel?.text = listCategory?[indexPath.row].name ?? "There are no Cathegories yet"
        
        cell.backgroundColor = UIColor(hexString: listCategory?[indexPath.row].color ?? "#0000")
        
        if let color = cell.backgroundColor?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((listCategory?.count)!)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        return cell
    }
     
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = listCategory?[indexPath.row]
        }
        
    }
    
    
    


  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (success) in
            print(success)
            
            if textField.text != "" {
                let categoryItem = Category()
                categoryItem.name = textField.text!
                categoryItem.color = UIColor.randomFlat.hexValue()
                self.tableView.reloadData()
                
                self.save(category: categoryItem)
                
            }
            
            
        }
        
        alert.addTextField { (textFieldAlert) in
            textFieldAlert.placeholder = "What`s category"
            textField = textFieldAlert
        }
        
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        

    }
    
    // delete
    override func updateModel(at indexPath: IndexPath) {
        if let objectsForDeletion = self.listCategory?[indexPath.row] {
            do {
            try self.realm.write {
                self.realm.delete(objectsForDeletion)
            }
            } catch {
            print("There is ana error,\(error)")
            }
        }
    }
    
    
    
    func save(category: Category) {
        
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        
    }
    
    func readCategory() {
        
       listCategory = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
}


