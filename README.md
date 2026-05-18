# HookSniff Swift SDK

<p align="center">
  <a href="https://github.com/servetarslan02/HookSniff"><img src="https://img.shields.io/github/license/servetarslan02/HookSniff" alt="License"></a>
</p>

Swift SDK for the [HookSniff](https://hooksniff.vercel.app) webhook delivery platform.

## Installation

```bash
.package(url: "https://github.com/servetarslan02/hooksniff-swift", from: "1.0.0")
```

## Quick Start

```swift
let client = HookSniff(apiKey: "hs_xxx")
let endpoints = try await client.endpoint.list()
print(endpoints)
```

## Webhook Verification

```swift
let wh = try Webhook(secret: "whsec_xxx")
let payload = try wh.verify(body: body, headers: headers)
```

## Resources

| Resource | Methods |
|----------|---------|
| Endpoint | list, create, get, update, delete |
| Message | create, list, get |
| MessageAttempt | list, listByMsg, get, resend |
| Authentication | dashboardAccess |
| EventType | list |
| Statistics | aggregate |

## Links

- [Documentation](https://hooksniff.vercel.app/docs)
- [API Reference](https://hooksniff-api-1046140057667.europe-west1.run.app)
- [GitHub](https://github.com/servetarslan02/HookSniff)
