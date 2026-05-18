import XCTest
@testable import HookSniff

final class TypedWebhookEventTests: XCTestCase {

    func testParseEndpointCreatedData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "data": ["appId": "a1", "endpointId": "e1", "appUid": "u1"],
            "timestamp": "2026-05-19"
        ])

        XCTAssertEqual(event.event, "endpoint.created")
        let data = event.parseEndpointCreatedData()
        XCTAssertNotNil(data)
        XCTAssertEqual(data?.appId, "a1")
        XCTAssertEqual(data?.endpointId, "e1")
        XCTAssertEqual(data?.appUid, "u1")
    }

    func testParseEndpointDisabledData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.disabled",
            "data": ["appId": "a1", "endpointId": "e1", "failSince": "2026-01", "trigger": "repeated-failure"],
            "timestamp": ""
        ])

        let data = event.parseEndpointDisabledData()
        XCTAssertNotNil(data)
        XCTAssertEqual(data?.failSince, "2026-01")
        XCTAssertEqual(data?.trigger, "repeated-failure")
    }

    func testParseMessageAttemptExhaustedData() {
        let event = WebhookEvent.parse([
            "event": "message.attempt.exhausted",
            "data": [
                "appId": "a1",
                "msgId": "m1",
                "lastAttempt": ["id": "att", "timestamp": "t", "responseStatusCode": 500] as [String: Any]
            ] as [String: Any],
            "timestamp": ""
        ])

        let data = event.parseMessageAttemptExhaustedData()
        XCTAssertNotNil(data)
        XCTAssertEqual(data?.msgId, "m1")
        XCTAssertEqual(data?.lastAttempt.responseStatusCode, 500)
    }

    func testParseMessageAttemptFailingData() {
        let event = WebhookEvent.parse([
            "event": "message.atattempt.failing",
            "data": [
                "appId": "a1",
                "msgId": "m1",
                "attempt": ["id": "att", "timestamp": "t", "responseStatusCode": 429] as [String: Any]
            ] as [String: Any],
            "timestamp": ""
        ])

        let data = event.parseMessageAttemptFailingData()
        XCTAssertNotNil(data)
        XCTAssertEqual(data?.attempt.responseStatusCode, 429)
    }

    func testParseMessageAttemptRecoveredData() {
        let event = WebhookEvent.parse([
            "event": "message.atattempt.recovered",
            "data": [
                "appId": "a1",
                "msgId": "m1",
                "attempt": ["id": "att", "timestamp": "t", "responseStatusCode": 200] as [String: Any]
            ] as [String: Any],
            "timestamp": ""
        ])

        let data = event.parseMessageAttemptRecoveredData()
        XCTAssertNotNil(data)
        XCTAssertEqual(data?.attempt.responseStatusCode, 200)
    }

    func testBackwardCompat() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "data": ["appId": "a1"] as [String: Any],
            "timestamp": "t"
        ])

        XCTAssertEqual(event.get("appId") as? String, "a1")
        XCTAssertEqual(event["appId"] as? String, "a1")
        XCTAssertEqual(event.eventType, "endpoint.created")
    }

    func testUnknownEventKeepsRawData() {
        let event = WebhookEvent.parse([
            "event": "custom.unknown",
            "data": ["x": 1] as [String: Any],
            "timestamp": ""
        ])

        XCTAssertEqual(event.event, "custom.unknown")
        XCTAssertEqual(event.get("x") as? Int, 1)
    }

    func testAllEndpointEventTypes() {
        let types = [
            "endpoint.created",
            "endpoint.updated",
            "endpoint.deleted",
            "endpoint.enabled",
            "endpoint.disabled",
        ]

        for eventType in types {
            let event = WebhookEvent.parse([
                "event": eventType,
                "data": ["appId": "a1", "endpointId": "e1"] as [String: Any],
                "timestamp": ""
            ])
            XCTAssertEqual(event.event, eventType)
        }
    }

    func testEmptyData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "data": [:] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointCreatedData()
        XCTAssertNotNil(data)
        XCTAssertEqual(data?.appId, "")
    }

    func testMissingDataKey() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "timestamp": ""
        ] as [String: Any])
        let data = event.parseEndpointCreatedData()
        XCTAssertNil(data)
    }

    func testUnicodeData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "data": ["appId": "ünïcödé", "endpointId": "日本語"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointCreatedData()
        XCTAssertEqual(data?.appId, "ünïcödé")
        XCTAssertEqual(data?.endpointId, "日本語")
    }

    func testEndpointUpdatedData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.updated",
            "data": ["appId": "a1", "endpointId": "e1"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointUpdatedData()
        XCTAssertEqual(data?.appId, "a1")
    }

    func testEndpointDeletedData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.deleted",
            "data": ["appId": "a1", "endpointId": "e1"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointDeletedData()
        XCTAssertEqual(data?.endpointId, "e1")
    }

    func testEndpointEnabledData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.enabled",
            "data": ["appId": "a1", "endpointId": "e1"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointEnabledData()
        XCTAssertEqual(data?.appId, "a1")
    }

    func testGetMissingKey() {
        let event = WebhookEvent.parse([
            "event": "test",
            "data": ["x": 1] as [String: Any],
            "timestamp": ""
        ])
        XCTAssertNil(event.get("missing"))
    }

    func testEventTypeProperty() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "data": [:] as [String: Any],
            "timestamp": "2026-05-19"
        ])
        XCTAssertEqual(event.eventType, "endpoint.created")
    }

    func testLargeData() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "data": ["appId": String(repeating: "a", count: 10000), "endpointId": String(repeating: "e", count: 10000)] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointCreatedData()
        XCTAssertEqual(data?.appId.count, 10000)
    }

    func testSpecialCharacters() {
        let event = WebhookEvent.parse([
            "event": "endpoint.created",
            "data": ["appId": "a@b.c", "endpointId": "e#1"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointCreatedData()
        XCTAssertEqual(data?.appId, "a@b.c")
    }

    func testTriggerNone() {
        let event = WebhookEvent.parse([
            "event": "endpoint.disabled",
            "data": ["appId": "a", "endpointId": "e", "trigger": "none"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointDisabledData()
        XCTAssertEqual(data?.trigger, "none")
    }

    func testTriggerFirstFailure() {
        let event = WebhookEvent.parse([
            "event": "endpoint.disabled",
            "data": ["appId": "a", "endpointId": "e", "trigger": "first-failure"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointDisabledData()
        XCTAssertEqual(data?.trigger, "first-failure")
    }

    func testFailSince() {
        let event = WebhookEvent.parse([
            "event": "endpoint.disabled",
            "data": ["appId": "a", "endpointId": "e", "failSince": "2026-01"] as [String: Any],
            "timestamp": ""
        ])
        let data = event.parseEndpointDisabledData()
        XCTAssertEqual(data?.failSince, "2026-01")
    }

    func testAllEndpointTypes() {
        for type in ["endpoint.created", "endpoint.updated", "endpoint.deleted", "endpoint.enabled", "endpoint.disabled"] {
            let event = WebhookEvent.parse(["event": type, "data": ["appId": "a"] as [String: Any], "timestamp": ""])
            XCTAssertEqual(event.event, type)
        }
    }

    func testGetExistingKey() {
        let event = WebhookEvent.parse(["event": "test", "data": ["x": 1] as [String: Any], "timestamp": ""])
        XCTAssertEqual(event.get("x") as? Int, 1)
    }

    func testSubscriptKey() {
        let event = WebhookEvent.parse(["event": "test", "data": ["x": 1] as [String: Any], "timestamp": ""])
        XCTAssertEqual(event["x"] as? Int, 1)
    }

    func testToString() {
        let event = WebhookEvent.parse(["event": "endpoint.created", "data": [:] as [String: Any], "timestamp": "2026-05-19"])
        XCTAssertNotNil(event.description)
    }
}
