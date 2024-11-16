import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "Running!"
        //LATER: req.redirect(to: "https://www.regexplanet.com/advanced/swift/index.html", redirectType: .normal)
    }

    app.get("test.json") { req -> Response in
        let testInput = try req.query.decode(TestInput.self)

        let retVal = RunTest(testInput);

        return try handleJsonp(req: req, from: retVal)
    }

    app.post("test.json") { req -> Response in
        let testInput = try req.content.decode(TestInput.self)

        let retVal = RunTest(testInput);

        return try handleJsonp(req: req, from: retVal)
    }

    app.get("status.json") { req -> Response in

        let retVal = StatusResponse(
            success: true,
            tech: "Swift v6.0",
            version: "swiftlang-6.0.0.9.10 clang-1600.0.26.2",
            commit: Environment.get("COMMIT") ?? "(local)",
            lastmod: Environment.get("LASTMOD") ?? "(local)",
            timestamp: ISO8601DateFormatter().string(from: Date())
        )

        return try handleJsonp(req: req, from: retVal)
    }
}

struct JsonpParams: Content {
    let callback: String
}

struct TestInput: Content {
    let regex: String?
    let replacement: String?
    let option: [String]?
    let input: [String]?
}

struct TestOutput: Content {
    let success: Bool
    let html: String?
    let message: String?
}

struct StatusResponse: Content {
    let success: Bool
    let tech: String
    let version: String
    let commit: String
    let lastmod: String
    let timestamp: String
}

func handleJsonp<T: Content>(req: Request, from content: T) throws -> Response {
    let jsonResponse = try JSONEncoder().encode(content)
    let jsonString = String(data: jsonResponse, encoding: .utf8) ?? ""

    var headers = HTTPHeaders()
    let callback = try? req.query.decode(JsonpParams.self).callback
    if let callback = callback {
        headers.add(name: .contentType, value: "application/javascript")
        return Response(
            status: .ok,
            headers: headers,
            body: .init(string: "\(callback)(\(jsonString))")
        )
    }

    headers.add(name: .contentType, value: "application/json")
    headers.add(name: "Access-Control-Allow-Origin", value: "*")
    headers.add(name: "Access-Control-Allow-Methods", value: "POST, GET")
    headers.add(name: "Access-Control-Max-Age", value: "604800")

    return Response(
        status: .ok,
        headers: headers,
        body: .init(string: jsonString)
    )
}