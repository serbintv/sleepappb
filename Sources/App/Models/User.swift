import FluentMySQL
import Vapor

/// A single entry of a Todo list.
final class User: MySQLModel {
    var id: Int?
    var deviceId: String?
    var dateStart: String?
    var date:String?
    enum JSONKey: String {
        case id = "id"
        case deviceId = "deviceId"
    }
    
    init(deviceId: String) {
        self.deviceId = deviceId
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(identifier: "UTC")
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.dateStart = dateFormat.string(from: Date())
        dateFormat.dateFormat = "dd-MM-yyyy"
        self.date = dateFormat.string(from: Date()) 
    }
}



/// Allows `Todo` to be used as a dynamic migration.
extension User: Migration {
    
}

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
