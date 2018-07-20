import Vapor
import Fluent

final class UserController: RouteCollection {
    func boot(router: Router) throws {
        let users = router.grouped("trial")
        users.post(use: create)
        users.get(String.parameter, use: show)
        users.delete(User.parameter, use:delete)
    }
    
    func create(_ request: Request) throws -> Future<User> {
        let deviceId:String = try request.content.syncGet(at: User.JSONKey.deviceId.rawValue)
        return User.query(on: request).filter(\User.deviceId == deviceId).first().flatMap { (user) in
            if user == nil {
                let user = User.init(deviceId: deviceId)
                return user.save(on: request)
            } else {
                throw Abort(.badRequest, reason: "User exist")
            }
        }
    }
    
    
    
    func show(_ request: Request) throws -> Future<User> {
        let deviceId = try request.parameters.next(String.self)
        return User.query(on: request).filter(\User.deviceId == deviceId).first().map(to: User.self) { user in
            guard let user = user else {
                throw Abort(.notFound, reason: "Could not find user.")
            }
            return user
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
            }.transform(to: .ok)
    }
}


