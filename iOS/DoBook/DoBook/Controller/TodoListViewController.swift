//
//  ViewController.swift
//  DoBook
//
//  Created by LeoChernyak on 05/04/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    //Outlets
    var listArr: Results<Item>?

    
    var selectedCategory: Category? {
        didSet{
            readItems()
        }
    }
    
//where is my data saved
//let dataFilePath = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        guard let colorHex = UIColor(hexString: selectedCategory!.color) else {fatalError()}
        guard let navBar = navigationController?.navigationBar else {(fatalError())}
            
        title = selectedCategory!.name
        
        
            
        navBar.barTintColor = colorHex
        navBar.tintColor = ContrastColorOf(colorHex, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(colorHex, returnFlat: true)]
        searchBar.barTintColor = colorHex
            
        
        
        
    }
    
    //Backing on a previous controller
    override func viewWillDisappear(_ animated: Bool) {
        
        updateUIViewMode()
        
    }
    
    
    
    //MARK: TableView Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = listArr?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((listArr?.count)!)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            //for unreusable cells
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            
        } else {
            cell.textLabel?.text = "There is no items Yet"
        }
        
       
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listArr?.count ?? 1
    }
    
    
    //MARK: - Table View Delegate METHODS
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //Updating
        if let item = listArr?[indexPath.row] {
            
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("There is error with updating realmData\(error)")
            }
            
        }
        
        tableView.reloadData()
        
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add new Outlets
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        
        var textFieldAlert = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (success) in
            
            print("Success")
            
            //Saving
            if let cathegory = self.selectedCategory {
                
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = textFieldAlert.text!
                        item.dateCreated = Date()
                        cathegory.items.append(item)
                    }
                    
                } catch {
                    print("There is an error\(error)")
                }
                
                self.tableView.reloadData()
                
                
                
            }
            
           
            
        }
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "What`s your item for today?"
            textFieldAlert = textField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: CoreData methods
    
    override func updateModel(at indexPath: IndexPath) {
        if let objectsForDeletion = self.listArr?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(objectsForDeletion)
                }
            } catch {
                print("There is ana error,\(error)")
            }
        }
    }
    
    
   
    
    
    func readItems() {
        
        //fetching data from realm

        listArr = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        self.tableView.reloadData()
    }

}


extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        listArr = listArr?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            readItems()

            //Reback and stop actions with searchbar on the foreground
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

