import Vapor
import Leaf
import Authentication


/// Register your application's routes here.
public func routes(_ router: Router) throws {
    try router.register(collection: UserController())
    router.get { request -> Future<View> in
        return try request.view().render("index")
    }
    router.get("error") { (request) -> Future<View> in
        let error = ["error":"Incorrect username or password"]
        return try request.view().render("error", error)
    }
    
    let adminController = AdminController()
    router.get("register", use: adminController.renderRegister)
    router.post("register", use: adminController.register)
    router.get("login", use: adminController.renderLogin)
    
    let authSessionRouter = router.grouped(Admin.authSessionsMiddleware())
    authSessionRouter.post("login", use: adminController.login)
    
    let protectedRouter = authSessionRouter.grouped(RedirectMiddleware<Admin>(path: "/"))
    protectedRouter.get("users", use: adminController.renderProfile)
}



