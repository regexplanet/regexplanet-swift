import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.http.server.configuration.hostname = Environment.get("HOSTNAME") ?? "0.0.0.0"
    app.http.server.configuration.port = Environment.get("PORT").flatMap(Int.init) ?? 4000
    app.http.server.configuration.serverName = "regexplanet-swift"

    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
}
