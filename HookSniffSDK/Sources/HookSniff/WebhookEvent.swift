import Foundation

// MARK: - Event Data Structs

/// Data payload for endpoint.created events.
public struct EndpointCreatedData {
    public let appId: String
    public let endpointId: String
    public let appUid: String?

    public init(appId: String, endpointId: String, appUid: String? = nil) {
        self.appId = appId
        self.endpointId = endpointId
        self.appUid = appUid
    }
}

/// Data payload for endpoint.updated events.
public struct EndpointUpdatedData {
    public let appId: String
    public let endpointId: String
    public let appUid: String?

    public init(appId: String, endpointId: String, appUid: String? = nil) {
        self.appId = appId
        self.endpointId = endpointId
        self.appUid = appUid
    }
}

/// Data payload for endpoint.deleted events.
public struct EndpointDeletedData {
    public let appId: String
    public let endpointId: String
    public let appUid: String?

    public init(appId: String, endpointId: String, appUid: String? = nil) {
        self.appId = appId
        self.endpointId = endpointId
        self.appUid = appUid
    }
}

/// Data payload for endpoint.enabled events.
public struct EndpointEnabledData {
    public let appId: String
    public let endpointId: String
    public let appUid: String?

    public init(appId: String, endpointId: String, appUid: String? = nil) {
        self.appId = appId
        self.endpointId = endpointId
        self.appUid = appUid
    }
}

/// Data payload for endpoint.disabled events.
public struct EndpointDisabledData {
    public let appId: String
    public let endpointId: String
    public let appUid: String?
    public let failSince: String?
    /// "none" | "first-failure" | "repeated-failure"
    public let trigger: String?

    public init(appId: String, endpointId: String, appUid: String? = nil, failSince: String? = nil, trigger: String? = nil) {
        self.appId = appId
        self.endpointId = endpointId
        self.appUid = appUid
        self.failSince = failSince
        self.trigger = trigger
    }
}

/// Info about the last delivery attempt.
public struct LastAttemptInfo {
    public let id: String
    public let timestamp: String
    public let responseStatusCode: Int

    public init(id: String, timestamp: String, responseStatusCode: Int) {
        self.id = id
        self.timestamp = timestamp
        self.responseStatusCode = responseStatusCode
    }
}

/// Info about a delivery attempt.
public struct AttemptInfo {
    public let id: String
    public let timestamp: String
    public let responseStatusCode: Int

    public init(id: String, timestamp: String, responseStatusCode: Int) {
        self.id = id
        self.timestamp = timestamp
        self.responseStatusCode = responseStatusCode
    }
}

/// Data payload for message.attempt.exhausted events.
public struct MessageAttemptExhaustedData {
    public let appId: String
    public let msgId: String
    public let lastAttempt: LastAttemptInfo
    public let appUid: String?

    public init(appId: String, msgId: String, lastAttempt: LastAttemptInfo, appUid: String? = nil) {
        self.appId = appId
        self.msgId = msgId
        self.lastAttempt = lastAttempt
        self.appUid = appUid
    }
}

/// Data payload for message.attempt.failing events.
public struct MessageAttemptFailingData {
    public let appId: String
    public let msgId: String
    public let attempt: AttemptInfo
    public let appUid: String?

    public init(appId: String, msgId: String, attempt: AttemptInfo, appUid: String? = nil) {
        self.appId = appId
        self.msgId = msgId
        self.attempt = attempt
        self.appUid = appUid
    }
}

/// Data payload for message.attempt.recovered events.
public struct MessageAttemptRecoveredData {
    public let appId: String
    public let msgId: String
    public let attempt: AttemptInfo
    public let appUid: String?

    public init(appId: String, msgId: String, attempt: AttemptInfo, appUid: String? = nil) {
        self.appId = appId
        self.msgId = msgId
        self.attempt = attempt
        self.appUid = appUid
    }
}

// MARK: - WebhookEvent (updated with typed parsing)

/// Represents a parsed webhook event from HookSniff.
///
/// Usage:
///     let event: WebhookEvent = try wh.verify(payload: body, headers: headers)
///     print(event.event)      // "endpoint.created"
///     print(event.data)       // ["endpointId": "ep_123", ...]
///
/// Typed access:
///     if let data = event.parseEndpointCreatedData() {
///         print(data.endpointId) // "ep_123"
///     }
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

    // MARK: - Typed Data Parsing

    /// Parse event data as EndpointCreatedData.
    public func parseEndpointCreatedData() -> EndpointCreatedData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let endpointId = data["endpointId"] as? String ?? data["endpoint_id"] as? String else { return nil }
        return EndpointCreatedData(appId: appId, endpointId: endpointId, appUid: data["appUid"] as? String ?? data["app_uid"] as? String)
    }

    /// Parse event data as EndpointUpdatedData.
    public func parseEndpointUpdatedData() -> EndpointUpdatedData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let endpointId = data["endpointId"] as? String ?? data["endpoint_id"] as? String else { return nil }
        return EndpointUpdatedData(appId: appId, endpointId: endpointId, appUid: data["appUid"] as? String ?? data["app_uid"] as? String)
    }

    /// Parse event data as EndpointDeletedData.
    public func parseEndpointDeletedData() -> EndpointDeletedData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let endpointId = data["endpointId"] as? String ?? data["endpoint_id"] as? String else { return nil }
        return EndpointDeletedData(appId: appId, endpointId: endpointId, appUid: data["appUid"] as? String ?? data["app_uid"] as? String)
    }

    /// Parse event data as EndpointEnabledData.
    public func parseEndpointEnabledData() -> EndpointEnabledData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let endpointId = data["endpointId"] as? String ?? data["endpoint_id"] as? String else { return nil }
        return EndpointEnabledData(appId: appId, endpointId: endpointId, appUid: data["appUid"] as? String ?? data["app_uid"] as? String)
    }

    /// Parse event data as EndpointDisabledData.
    public func parseEndpointDisabledData() -> EndpointDisabledData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let endpointId = data["endpointId"] as? String ?? data["endpoint_id"] as? String else { return nil }
        return EndpointDisabledData(
            appId: appId, endpointId: endpointId,
            appUid: data["appUid"] as? String ?? data["app_uid"] as? String,
            failSince: data["failSince"] as? String ?? data["fail_since"] as? String,
            trigger: data["trigger"] as? String
        )
    }

    /// Parse event data as MessageAttemptExhaustedData.
    public func parseMessageAttemptExhaustedData() -> MessageAttemptExhaustedData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let msgId = data["msgId"] as? String ?? data["msg_id"] as? String,
              let lastRaw = data["lastAttempt"] as? [String: Any] ?? data["last_attempt"] as? [String: Any] else { return nil }
        let lastAttempt = LastAttemptInfo(
            id: lastRaw["id"] as? String ?? "",
            timestamp: lastRaw["timestamp"] as? String ?? "",
            responseStatusCode: lastRaw["responseStatusCode"] as? Int ?? lastRaw["response_status_code"] as? Int ?? 0
        )
        return MessageAttemptExhaustedData(appId: appId, msgId: msgId, lastAttempt: lastAttempt, appUid: data["appUid"] as? String ?? data["app_uid"] as? String)
    }

    /// Parse event data as MessageAttemptFailingData.
    public func parseMessageAttemptFailingData() -> MessageAttemptFailingData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let msgId = data["msgId"] as? String ?? data["msg_id"] as? String,
              let attRaw = data["attempt"] as? [String: Any] else { return nil }
        let attempt = AttemptInfo(
            id: attRaw["id"] as? String ?? "",
            timestamp: attRaw["timestamp"] as? String ?? "",
            responseStatusCode: attRaw["responseStatusCode"] as? Int ?? attRaw["response_status_code"] as? Int ?? 0
        )
        return MessageAttemptFailingData(appId: appId, msgId: msgId, attempt: attempt, appUid: data["appUid"] as? String ?? data["app_uid"] as? String)
    }

    /// Parse event data as MessageAttemptRecoveredData.
    public func parseMessageAttemptRecoveredData() -> MessageAttemptRecoveredData? {
        guard let appId = data["appId"] as? String ?? data["app_id"] as? String,
              let msgId = data["msgId"] as? String ?? data["msg_id"] as? String,
              let attRaw = data["attempt"] as? [String: Any] else { return nil }
        let attempt = AttemptInfo(
            id: attRaw["id"] as? String ?? "",
            timestamp: attRaw["timestamp"] as? String ?? "",
            responseStatusCode: attRaw["responseStatusCode"] as? Int ?? attRaw["response_status_code"] as? Int ?? 0
        )
        return MessageAttemptRecoveredData(appId: appId, msgId: msgId, attempt: attempt, appUid: data["appUid"] as? String ?? data["app_uid"] as? String)
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case event
        case data
        case timestamp
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event = try container.decodeIfPresent(String.self, forKey: .event) ?? ""
        timestamp = try container.decodeIfPresent(String.self, forKey: .timestamp) ?? ""

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
