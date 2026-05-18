import Foundation

/// Base error for all HookSniff API errors.
public struct HookSniffApiError: Error, LocalizedError {
    public let statusCode: Int
    public let message: String
    public let responseBody: String?
    public let headers: [String: String]

    public init(statusCode: Int, message: String, responseBody: String? = nil, headers: [String: String] = [:]) {
        self.statusCode = statusCode
        self.message = message
        self.responseBody = responseBody
        self.headers = headers
    }

    public var errorDescription: String? { "HookSniff API Error \(statusCode): \(message)" }
}

/// 400 Bad Request — The request was malformed or missing required fields
public struct BadRequestError: Error, LocalizedError {
    public let detail: String?
    public let headers: [String: String]
    public init(detail: String? = nil, headers: [String: String] = [:]) { self.detail = detail; self.headers = headers }
    public var errorDescription: String? { detail ?? "Bad request" }
}

/// 401 Unauthorized — Invalid or missing authentication
public struct UnauthorizedError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Unauthorized", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 403 Forbidden — Insufficient permissions
public struct ForbiddenError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Forbidden", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 404 Not Found — Resource does not exist
public struct NotFoundError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Not found", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 409 Conflict — Resource already exists or conflict
public struct ConflictError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Conflict", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 422 Unprocessable Entity — Validation error
public struct UnprocessableEntityError: Error, LocalizedError {
    public let validationErrors: [ValidationErrorItem]
    public let message: String
    public let headers: [String: String]
    public init(validationErrors: [ValidationErrorItem] = [], message: String = "Unprocessable entity", headers: [String: String] = [:]) {
        self.validationErrors = validationErrors; self.message = message; self.headers = headers
    }
    public var errorDescription: String? { message }
}

/// 429 Too Many Requests — Rate limit exceeded
public struct RateLimitError: Error, LocalizedError {
    public let retryAfter: Int?
    public let headers: [String: String]
    public init(retryAfter: Int? = nil, headers: [String: String] = [:]) { self.retryAfter = retryAfter; self.headers = headers }
    public var errorDescription: String? {
        retryAfter != nil ? "Rate limit exceeded (retry after \(retryAfter!)s)" : "Rate limit exceeded"
    }
}

/// 500 Internal Server Error
public struct InternalServerError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Internal server error", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 502 Bad Gateway
public struct BadGatewayError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Bad gateway", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 503 Service Unavailable
public struct ServiceUnavailableError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Service unavailable", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 504 Gateway Timeout
public struct GatewayTimeoutError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Gateway timeout", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// Validation error item from 422 responses
public struct ValidationErrorItem {
    public let loc: [String]
    public let msg: String
    public let type: String
}

/// Factory to create the appropriate error from a status code.
public enum HookSniffErrorFactory {
    public static func create(statusCode: Int, body: String?, headers: [String: String] = [:]) -> Error {
        switch statusCode {
        case 400: return BadRequestError(detail: body, headers: headers)
        case 401: return UnauthorizedError(message: body ?? "Unauthorized", headers: headers)
        case 403: return ForbiddenError(message: body ?? "Forbidden", headers: headers)
        case 404: return NotFoundError(message: body ?? "Not found", headers: headers)
        case 409: return ConflictError(message: body ?? "Conflict", headers: headers)
        case 422: return UnprocessableEntityError(message: body ?? "Unprocessable entity", headers: headers)
        case 429:
            let retryAfter = headers["retry-after"].flatMap { Int($0) }
            return RateLimitError(retryAfter: retryAfter, headers: headers)
        case 500: return InternalServerError(message: body ?? "Internal server error", headers: headers)
        case 502: return BadGatewayError(message: body ?? "Bad gateway", headers: headers)
        case 503: return ServiceUnavailableError(message: body ?? "Service unavailable", headers: headers)
        case 504: return GatewayTimeoutError(message: body ?? "Gateway timeout", headers: headers)
        case 408: return RequestTimeoutError(message: body ?? "Request timeout", headers: headers)
        case 410: return GoneError(message: body ?? "Gone", headers: headers)
        case 413: return PayloadTooLargeError(message: body ?? "Payload too large", headers: headers)
        case 501: return NotImplementedError(message: body ?? "Not implemented", headers: headers)
        case 507: return InsufficientStorageError(message: body ?? "Insufficient storage", headers: headers)
        case 508: return LoopDetectedError(message: body ?? "Loop detected", headers: headers)(message: body ?? "Gateway timeout", headers: headers)
        default: return HookSniffApiError(statusCode: statusCode, message: body ?? "HTTP \(statusCode)", headers: headers)
        }
    }
}

/// 408 Request Timeout — The server timed out waiting for the request
public struct RequestTimeoutError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Request timeout", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 410 Gone — The resource has been permanently removed
public struct GoneError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Gone", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 413 Payload Too Large
public struct PayloadTooLargeError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Payload too large", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 501 Not Implemented
public struct NotImplementedError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Not implemented", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 507 Insufficient Storage
public struct InsufficientStorageError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Insufficient storage", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// 508 Loop Detected
public struct LoopDetectedError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Loop detected", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}

/// Timeout — request exceeded the configured timeout
public struct TimeoutError: Error, LocalizedError {
    public let message: String
    public init(message: String = "Request timeout") { self.message = message }
    public var errorDescription: String? { message }
}

/// Network error — connection failed
public struct NetworkError: Error, LocalizedError {
    public let message: String
    public init(message: String = "Network error") { self.message = message }
    public var errorDescription: String? { message }
}

/// Authentication error — token invalid, expired, or missing
public struct AuthenticationError: Error, LocalizedError {
    public let message: String
    public let headers: [String: String]
    public init(message: String = "Authentication failed", headers: [String: String] = [:]) { self.message = message; self.headers = headers }
    public var errorDescription: String? { message }
}
