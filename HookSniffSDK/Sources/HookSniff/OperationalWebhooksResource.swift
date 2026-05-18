import Foundation

/// OperationalWebhooks resource — manage operational webhook endpoints and deliveries.
public final class OperationalWebhooksResource {
    private let client: HookSniff

    init(client: HookSniff) { self.client = client }

    /// List all operational webhook endpoints.
    public func list() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/operational-webhooks")
    }

    /// Create an operational webhook endpoint.
    public func create(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/operational-webhooks", body: body)
    }

    /// Get an operational webhook endpoint by ID.
    public func get(_ id: String) async throws -> [String: Any] {
        try await client.requestDict(method: "GET", path: "/v1/operational-webhooks/\(id)")
    }

    /// Update an operational webhook endpoint.
    public func update(_ id: String, _ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "PUT", path: "/v1/operational-webhooks/\(id)", body: body)
    }

    /// Delete an operational webhook endpoint.
    public func delete(_ id: String) async throws {
        try await client.requestVoid(method: "DELETE", path: "/v1/operational-webhooks/\(id)")
    }

    /// List deliveries for an operational webhook.
    public func listDeliveries(_ id: String) async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/operational-webhooks/\(id)/deliveries")
    }
}
