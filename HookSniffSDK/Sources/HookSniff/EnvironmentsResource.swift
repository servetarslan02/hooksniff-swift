import Foundation

/// Environments resource — manage environments and their variables.
public final class EnvironmentsResource {
    private let client: HookSniff

    init(client: HookSniff) { self.client = client }

    /// List all environments.
    public func list() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/environments")
    }

    /// Create a new environment.
    public func create(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/environments", body: body)
    }

    /// Get an environment by ID.
    public func get(_ id: String) async throws -> [String: Any] {
        try await client.requestDict(method: "GET", path: "/v1/environments/\(id)")
    }

    /// Update an environment.
    public func update(_ id: String, _ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "PATCH", path: "/v1/environments/\(id)", body: body)
    }

    /// Delete an environment.
    public func delete(_ id: String) async throws {
        try await client.requestVoid(method: "DELETE", path: "/v1/environments/\(id)")
    }

    /// List variables for an environment.
    public func listVariables(_ envId: String) async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/environments/\(envId)/variables")
    }

    /// Get a specific variable.
    public func getVariable(_ envId: String, _ varId: String) async throws -> [String: Any] {
        try await client.requestDict(method: "GET", path: "/v1/environments/\(envId)/variables/\(varId)")
    }

    /// Create a variable in an environment.
    public func createVariable(_ envId: String, _ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/environments/\(envId)/variables", body: body)
    }

    /// Update a variable.
    public func updateVariable(_ envId: String, _ varId: String, _ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "PUT", path: "/v1/environments/\(envId)/variables/\(varId)", body: body)
    }

    /// Delete a variable.
    public func deleteVariable(_ envId: String, _ varId: String) async throws {
        try await client.requestVoid(method: "DELETE", path: "/v1/environments/\(envId)/variables/\(varId)")
    }
}
