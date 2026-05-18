import Foundation

/// ConnectorResource — manage connectors and their configurations.
public final class ConnectorResource {
    private let client: HookSniff

    init(client: HookSniff) { self.client = client }

    /// List all available connectors.
    public func list() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/connectors")
    }

    /// Get a connector by ID.
    public func get(_ id: String) async throws -> [String: Any] {
        try await client.requestDict(method: "GET", path: "/v1/connectors/\(id)")
    }

    /// List connector configurations.
    public func listConfigs() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/connectors/configs")
    }

    /// Create a connector configuration.
    public func createConfig(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/connectors/configs", body: body)
    }

    /// Update a connector configuration.
    public func updateConfig(_ id: String, _ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "PUT", path: "/v1/connectors/configs/\(id)", body: body)
    }

    /// Delete a connector configuration.
    public func deleteConfig(_ id: String) async throws {
        try await client.requestVoid(method: "DELETE", path: "/v1/connectors/configs/\(id)")
    }
}
