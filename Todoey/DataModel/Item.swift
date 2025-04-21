import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdAt: Date = Date()
    var parentCategory = LinkingObjects<Category>(fromType: Category.self, property: "items")
}
