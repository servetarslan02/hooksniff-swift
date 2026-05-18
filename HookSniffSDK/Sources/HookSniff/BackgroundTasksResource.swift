import Foundation

/// BackgroundTasks resource — list, get, and cancel background tasks.
public final class BackgroundTasksResource {
    private let client: HookSniff

    init(client: HookSniff) { self.client = client }

    /// List all background tasks.
    public func list() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/background-tasks")
    }

    /// Get a specific task by ID.
    public func get(_ taskId: String) async throws -> [String: Any] {
        try await client.requestDict(method: "GET", path: "/v1/background-tasks/\(taskId)")
    }

    /// Cancel a running task.
    public func cancel(_ taskId: String) async throws -> [String: Any] {
        try await client.requestDict(method: "PUT", path: "/v1/background-tasks/\(taskId)")
    }
}
