import Foundation

/// Response metadata from the last API request.
///
/// Usage:
///     let endpoints = try client.endpoints.list()
///     if let meta = client.lastResponse {
///         print(meta.requestId)
///         print(meta.rateLimitRemaining)
///     }
public struct ResponseMetadata {
    /// HTTP status code
    public let statusCode: Int

    /// x-request-id header (for debugging with HookSniff support)
    public let requestId: String?

    /// x-ratelimit-remaining header
    public let rateLimitRemaining: Int?

    /// x-ratelimit-reset header (Unix timestamp)
    public let rateLimitReset: Int?

    /// All response headers
    public let headers: [String: String]

    public init(statusCode: Int, requestId: String? = nil, rateLimitRemaining: Int? = nil,
                rateLimitReset: Int? = nil, headers: [String: String] = [:]) {
        self.statusCode = statusCode
        self.requestId = requestId
        self.rateLimitRemaining = rateLimitRemaining
        self.rateLimitReset = rateLimitReset
        self.headers = headers
    }

    /// Create from HTTP URL response.
    public static func from(_ response: HTTPURLResponse) -> ResponseMetadata {
        let headerDict = (response.allHeaderFields as? [String: String]) ?? [:]
        return ResponseMetadata(
            statusCode: response.statusCode,
            requestId: headerDict["x-request-id"],
            rateLimitRemaining: headerDict["x-ratelimit-remaining"].flatMap(Int.init),
            rateLimitReset: headerDict["x-ratelimit-reset"].flatMap(Int.init),
            headers: headerDict
        )
    }
}
