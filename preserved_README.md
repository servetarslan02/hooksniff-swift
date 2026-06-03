# HookSniff Swift SDK

<p align="center">
  <a href="https://github.com/servetarslan02/hooksniff-swift"><img src="https://img.shields.io/github/license/servetarslan02/hooksniff-swift" alt="License"></a>
</p>

Swift SDK for the [HookSniff](https://hooksniff.vercel.app) webhook delivery platform.

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/servetarslan02/hooksniff-swift", from: "1.2.0")
]
```

## Quick Start

```swift
import HookSniffSDK

let client = HookSniff(apiKey: "hooksniff_xxx")

// List endpoints
let endpoints = try await client.endpoint.list()

// Send a webhook
let delivery = try await client.message.create(
    endpointId: "ep_xxx",
    event: "order.created",
    data: ["order_id": "123", "amount": 99.99]
)
```

## Webhook Verification

```swift
let wh = try Webhook(secret: "whsec_xxx")
let payload = try wh.verify(body: body, headers: headers)
```

## API Resources

| Resource | Methods |
|----------|---------|
| Endpoint | list, create, get, update, delete |
| Message | create, list, get |
| MessageAttempt | list, listByMsg, get, resend |
| Authentication | login, register, logout |
| EventType | list, create, get, update, delete |
| Stream | listChannels, getChannel, createChannel, subscribe, publish |
| BackgroundTask | list, get |
| Connector | list, get |
| Integration | list, get, create, update, delete |
| Inbound | list, create, get, delete |
| Statistics | aggregate |

## Features

- ✅ HMAC-SHA256 webhook verification
- ✅ Typed webhook events
- ✅ Automatic retry with exponential backoff
- ✅ Pagination helpers
- ✅ Rate limit header parsing
- ✅ SSE streaming
- ✅ Idempotency keys
- ✅ Configurable URLSession

## Links

- [Documentation](https://hooksniff.vercel.app/docs)
- [GitHub](https://github.com/servetarslan02/HookSniff)

## License

MIT
