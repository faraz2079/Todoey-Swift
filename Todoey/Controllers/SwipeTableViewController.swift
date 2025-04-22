import UIKit
import RealmSwift
import SwipeCellKit

// the parent class can't know about the childern classes (e.g. TodoListVC, CategoryVC)
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.rowHeight = 80.0
    }
    
    //TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
 
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    // this tries to delete the last row on the tableView, so when we use this method we should remove the "tableView.reloadData" otherwise the app crashes, but if we don't use this method, we should include the "tableView.reloadData"
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
//        options.transitionStyle = .reveal
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // update our DataModel
        
    }
}
