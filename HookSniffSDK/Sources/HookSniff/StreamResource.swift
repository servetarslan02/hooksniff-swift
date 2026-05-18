import Foundation

/// Stream resource — manage stream channels, messages, subscriptions.
public final class StreamResource {
    private let client: HookSniff

    init(client: HookSniff) { self.client = client }

    /// List all stream channels.
    public func listChannels() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/stream/channels")
    }

    /// Get channel details.
    public func getChannel(_ id: String) async throws -> [String: Any] {
        try await client.requestDict(method: "GET", path: "/v1/stream/channels/\(id)")
    }

    /// Create a stream channel.
    public func createChannel(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/stream/channels", body: body)
    }

    /// Update a channel.
    public func updateChannel(_ id: String, _ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "PUT", path: "/v1/stream/channels/\(id)", body: body)
    }

    /// Delete a channel.
    public func deleteChannel(_ id: String) async throws {
        try await client.requestVoid(method: "DELETE", path: "/v1/stream/channels/\(id)")
    }

    /// List messages for a channel.
    public func listMessages(_ channelId: String) async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/stream/channels/\(channelId)/messages")
    }

    /// List active subscriptions.
    public func listSubscriptions() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/stream/subscriptions")
    }

    /// Disconnect a subscription.
    public func disconnectSubscription(_ id: String) async throws {
        try await client.requestVoid(method: "DELETE", path: "/v1/stream/subscriptions/\(id)")
    }

    /// Publish an event to a channel.
    public func publish(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/stream/events", body: body)
    }
}
