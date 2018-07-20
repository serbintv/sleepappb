
import FluentMySQL
import Vapor
import Authentication

final class Admin: MySQLModel {
    var id: Int?
    var username:String
    var password:String
    
    init(id: Int? = nil, username: String, password:String) {
        self.id = id
        self.username = username
        self.password = password
    }
}
extension Admin: Content {}
extension Admin: Migration {}

extension Admin: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<Admin, String> {
        return \Admin.username
    }
    static var passwordKey: WritableKeyPath<Admin, String> {
        return \Admin.password
    }
}
extension Admin: SessionAuthenticatable {}
