import Vapor
import FluentSQL
import Crypto

final class AdminController {
    func renderRegister(_ req: Request) throws -> Future<View> {
        return try req.view().render("register")
    }
    
    func register(_ req:Request) throws -> Future<Response> {
        return try req.content.decode(Admin.self).flatMap { admin in
            return try Admin.query(on: req).filter(\Admin.username == admin.username).first().flatMap { result in
                if let _ = result {
                    return Future.map(on: req) {
                        return req.redirect(to: "/register")
                    }
                }
                admin.password = try BCryptDigest().hash(admin.password)
                return admin.save(on: req).map {_ in
                    return req.redirect(to: "/")
                }
            }
        }
    }
    
    func renderLogin(_ req:Request) throws -> Future<View> {
        return try req.view().render("index")
    }
    
    func login(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(Admin.self).flatMap { admin in
            return Admin.authenticate(
                username: admin.username,
                password: admin.password,
                using: BCryptDigest(),
                on: req
                ).map { admin in
                    guard let admin = admin else {
                        return req.redirect(to: "/")
                    }
                    try req.authenticateSession(admin)
                    return req.redirect(to: "users")
            }
        }
    }
    
    func renderProfile(_ req: Request) throws -> Future<View> {
        let users = ["users":User.query(on: req).all()]
        return try req.view().render("users", users)
    }
}
