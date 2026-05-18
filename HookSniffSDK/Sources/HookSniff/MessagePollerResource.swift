import Foundation

/// MessagePollerResource — poll, seek, commit message cursor.
public final class MessagePollerResource {
    private let client: HookSniff

    init(client: HookSniff) { self.client = client }

    /// Poll messages from the poller.
    public func poll() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/message-poller/poll")
    }

    /// Poll messages with query parameters.
    public func poll(params: [String: String]) async throws -> [[String: Any]] {
        var path = "/v1/message-poller/poll"
        let query = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        if !query.isEmpty { path += "?" + query }
        return try await client.requestArray(method: "GET", path: path)
    }

    /// Seek the poller cursor to a specific position.
    public func seek(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/message-poller/seek", body: body)
    }

    /// Commit the poller cursor (acknowledge consumed messages).
    public func commit() async throws {
        try await client.requestVoid(method: "POST", path: "/v1/message-poller/commit")
    }
}
