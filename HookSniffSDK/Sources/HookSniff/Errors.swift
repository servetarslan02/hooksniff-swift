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
        default: return HookSniffApiError(statusCode: statusCode, message: body ?? "HTTP \(statusCode)", headers: headers)
        }
    }
}
