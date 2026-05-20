import Foundation

/// Event Types resource — manage event types and import from OpenAPI.
public final class EventTypesResource {
    private let client: HookSniff

    init(client: HookSniff) {
        self.client = client
    }

    // MARK: - List

    /// List all event types (first page, default limit).
    public func list() async throws -> [[String: Any]] {
        let body = try await client.requestJSON(method: "GET", path: "/v1/event-types")
        return JSONHelpers.dataArray(from: body)
    }

    /// List event types with explicit pagination.
    public func list(limit: Int, offset: Int, includeArchived: Bool = false) async throws -> Pagination.Page<[String: Any]> {
        var path = "/v1/event-types?limit=\(limit)&offset=\(offset)"
        if includeArchived { path += "&include_archived=true" }
        let body = try await client.requestJSON(method: "GET", path: path)
        return Pagination.Page(
            data: JSONHelpers.dataArray(from: body),
            hasMore: JSONHelpers.hasMore(from: body)
        )
    }

    /// Collect all event types across all pages.
    public func listAll(limit: Int = Pagination.defaultLimit) async throws -> [[String: Any]] {
        return try await Pagination.collectAll(limit: limit) { l, o in
            try await self.list(limit: l, offset: o)
        }
    }

    // MARK: - CRUD

    /// Get a single event type by name.
    public func get(_ name: String) async throws -> [String: Any] {
        let body = try await client.requestJSON(method: "GET", path: "/v1/event-types/\(name)")
        return JSONHelpers.dict(from: body)
    }

    /// Create a new event type.
    public func create(_ params: [String: Any]) async throws -> [String: Any] {
        let body = try await client.requestJSON(method: "POST", path: "/v1/event-types", body: params)
        return JSONHelpers.dict(from: body)
    }

    /// Update an event type.
    public func update(_ name: String, params: [String: Any]) async throws -> [String: Any] {
        let body = try await client.requestJSON(method: "PUT", path: "/v1/event-types/\(name)", body: params)
        return JSONHelpers.dict(from: body)
    }

    /// Partially update an event type.
    public func patch(_ name: String, params: [String: Any]) async throws -> [String: Any] {
        let body = try await client.requestJSON(method: "PATCH", path: "/v1/event-types/\(name)", body: params)
        return JSONHelpers.dict(from: body)
    }

    /// Delete an event type.
    public func delete(_ name: String) async throws {
        _ = try await client.request(method: "DELETE", path: "/v1/event-types/\(name)")
    }

    // MARK: - OpenAPI Import

    /// Import event types from an OpenAPI spec.
    ///
    /// - Parameters:
    ///   - params: Dictionary with:
    ///     - `spec` (optional): A pre-parsed JSON spec (dictionary)
    ///     - `specRaw` (optional): A string, parsed by the server as YAML or JSON
    ///     - `dryRun` (optional): If `true`, return types without modifying
    ///     - `replaceAll` (optional): If `true`, archive types not in spec
    /// - Returns: Dictionary with `data.modified` and `data.toModify` arrays
    public func importOpenAPI(_ params: [String: Any]) async throws -> [String: Any] {
        let body = try await client.requestJSON(method: "POST", path: "/v1/event-types/import-openapi", body: params)
        return JSONHelpers.dict(from: body)
    }
}
