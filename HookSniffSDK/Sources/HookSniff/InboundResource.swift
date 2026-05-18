import Foundation

/// InboundResource — manage inbound webhook configurations and handle inbound webhooks.
public final class InboundResource {
    private let client: HookSniff

    init(client: HookSniff) { self.client = client }

    /// List inbound configurations.
    public func listConfigs() async throws -> [[String: Any]] {
        try await client.requestArray(method: "GET", path: "/v1/inbound/configs")
    }

    /// Create an inbound configuration.
    public func createConfig(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/inbound/configs", body: body)
    }

    /// Handle an inbound webhook.
    public func handle(_ body: [String: Any]) async throws -> [String: Any] {
        try await client.requestDict(method: "POST", path: "/v1/inbound", body: body)
    }
}
