# 🪝 HookSniff Swift SDK

[![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Official Swift client for [HookSniff](https://hooksniff.vercel.app) webhook delivery service.

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/servetarslan02/hooksniff-swift.git", from: "0.3.0")
]
```

Then add `"HookSniff"` to your target's dependencies.

### Xcode

1. File → Add Package Dependencies
2. Enter: `https://github.com/servetarslan02/hooksniff-swift.git`
3. Select "Up to Next Major Version" → `0.3.0`

## Quick Start

```swift
import HookSniff

// Configure the SDK
OpenAPIAPI.basePath = "https://hooksniff-api-1046140057667.europe-west1.run.app"

// Create an endpoint
let endpoint = CreateEndpointRequest(url: "https://your-app.com/webhook")

// Send a webhook
let webhook = CreateWebhookRequest(
    endpointId: "YOUR_ENDPOINT_ID",
    event: "order.created",
    data: ["order_id": "12345"]
)
```

## Documentation

- [API Reference](docs/)
- [HookSniff Documentation](https://hooksniff.vercel.app)

## License

MIT — see [LICENSE](LICENSE) for details.
