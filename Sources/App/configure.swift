import FluentMySQL
import Leaf
import Vapor
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first

    try services.register(FluentMySQLProvider())
    try services.register(FluentProvider())
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    let serverConfiure = NIOServerConfig.default(hostname: "localhost", port: 8080)
    services.register(serverConfiure)
    

   
//    let mysqlConfig = MySQLDatabaseConfig(
//        hostname: "127.0.0.1",
//        port: 3306,
//        username: "root",
//        password: "STarichOK82",
//        database: "sleepappDB"
//    )
    let mysqlConfig = MySQLDatabaseConfig()
    services.register(mysqlConfig)
    

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self)
    middlewares.use(SessionsMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .mysql)
    migrations.add(model: Admin.self, database: .mysql)
    services.register(migrations)

    var commands = CommandConfig.default()
    commands.useFluentCommands()
    services.register(commands)
    
    services.register(middlewares)
    
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
