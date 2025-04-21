import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() //this list comes from Realm -- and this is also the relationship 
}
