import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        //everything inside the didset triggers as soon as the selectedCategory gets a value
        didSet {
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // "appending... creates a file with any name we want in the path that got specified"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // tells the table how many cells to show.
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //how we should display each of the cells
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none // we can also remove the " == true"
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //updating & deleting in realm
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                   //deleting in realm
                   // realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks add item button on our UIAlert
            
            // creating in realm
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving new items\(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Read and Write Methods
    
    func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print("error saving context \(error)")
//        }
        
        tableView.reloadData()
    } 
    
    func loadItems() { //this method has default value
        
        // keypath here is originally the variable name that we defined in the DataBase classes
        todoItems = selectedCategory?.items.sorted(byKeyPath: "createdAt", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - SearchBar Extension

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        //Querying in Realm
        // keypath here is originally the variable name that we defined in the DataBase classes
        todoItems = todoItems?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "createdAt", ascending: true)
        
        DispatchQueue.main.async { // we put the resigner here so the task gets done in the background
            searchBar.resignFirstResponder() // cancels the keyboard after emptying the searchbar text
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async { // we put the resigner here so the task gets done in the background
                searchBar.resignFirstResponder() // cancels the keyboard after emptying the searchbar text
            }
        }
    }
    
}

