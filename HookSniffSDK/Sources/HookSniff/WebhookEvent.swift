import Foundation

/// Represents a parsed webhook event from HookSniff.
///
/// Usage:
///     let event: WebhookEvent = try wh.verify(payload: body, headers: headers)
///     print(event.event)      // "endpoint.created"
///     print(event.data)       // ["endpointId": "ep_123", ...]
///     print(event.timestamp)  // "2026-05-19T02:33:00Z"
public struct WebhookEvent: Codable {
    /// Event type name (e.g., "endpoint.created")
    public let event: String

    /// Event payload data
    public let data: [String: Any]

    /// ISO 8601 timestamp string
    public let timestamp: String

    /// Alias for `event` — the event type name
    public var eventType: String { event }

    public init(event: String, data: [String: Any], timestamp: String) {
        self.event = event
        self.data = data
        self.timestamp = timestamp
    }

    /// Get a value from the data dictionary by key.
    public func get(_ key: String) -> Any? {
        return data[key]
    }

    /// Access data values with subscript notation.
    public subscript(key: String) -> Any? {
        return data[key]
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case event
        case data
        case timestamp
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event = try container.decodeIfPresent(String.self, forKey: .event)
            ?? container.decodeIfPresent(String.self, forKey: .event) ?? ""
        timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? ""

        // Decode data as generic dictionary
        if let rawData = try? container.decodeIfPresent([String: AnyCodable].self, forKey: .data) {
            data = rawData.mapValues { $0.value }
        } else {
            data = [:]
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(event, forKey: .event)
        try container.encode(timestamp, forKey: .timestamp)
    }

    // MARK: - Parsing

    /// Parse a JSON dictionary into a WebhookEvent.
    public static func parse(_ json: [String: Any]) -> WebhookEvent {
        let event = json["event"] as? String ?? json["eventType"] as? String ?? ""
        let data = json["data"] as? [String: Any] ?? [:]
        let timestamp = json["timestamp"] as? String ?? ""

        return WebhookEvent(event: event, data: data, timestamp: timestamp)
    }
}

// MARK: - AnyCodable Helper

/// A type-erasing wrapper for Codable conformance of Any values.
internal struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues { $0.value }
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        default:
            try container.encodeNil()
        }
    }
}
