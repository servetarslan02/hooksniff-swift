import Foundation

/// Pagination Helper for HookSniff Swift SDK.
///
/// Usage:
///   let paginator = Paginator(limit: 100) { opts in
///       try await hs.message.list(limit: opts.limit, iterator: opts.iterator)
///   }
///   for try await msg in paginator {
///       print(msg.id)
///   }
///
///   // Or collect all
///   let all = try await paginator.collect()

/// Generic list response with pagination info.
public struct ListResponse<T> {
    public let data: [T]
    public let done: Bool
    public let iterator: String?

    public init(data: [T], done: Bool, iterator: String? = nil) {
        self.data = data
        self.done = done
        self.iterator = iterator
    }
}

/// Options for list requests.
public struct ListOptions {
    public let limit: Int?
    public let iterator: String?

    public init(limit: Int? = nil, iterator: String? = nil) {
        self.limit = limit
        self.iterator = iterator
    }
}

/// Async sequence that auto-paginates through all items.
public struct Paginator<T>: AsyncSequence {
    public typealias AsyncIterator = PaginatorIterator
    public typealias Element = T

    private let fetchPage: (ListOptions) async throws -> ListResponse<T>
    private let limit: Int?

    public init(limit: Int? = nil, fetchPage: @escaping (ListOptions) async throws -> ListResponse<T>) {
        self.limit = limit
        self.fetchPage = fetchPage
    }

    public func makeAsyncIterator() -> PaginatorIterator {
        PaginatorIterator(fetchPage: fetchPage, limit: limit)
    }

    /// Collect all items into an array.
    public func collect() async throws -> [T] {
        var items: [T] = []
        for try await item in self {
            items.append(item)
        }
        return items
    }

    public struct PaginatorIterator: AsyncIteratorProtocol {
        private let fetchPage: (ListOptions) async throws -> ListResponse<T>
        private let limit: Int?
        private var currentPage: ListResponse<T>?
        private var currentIndex: Int = 0
        private var iterator: String?
        private var done: Bool = false

        init(fetchPage: @escaping (ListOptions) async throws -> ListResponse<T>, limit: Int?) {
            self.fetchPage = fetchPage
            self.limit = limit
        }

        public mutating func next() async throws -> T? {
            if done { return nil }

            // Fetch first page if needed
            if currentPage == nil {
                currentPage = try await fetchPage(ListOptions(limit: limit, iterator: iterator))
                currentIndex = 0
            }

            guard let page = currentPage else { return nil }

            // Return items from current page
            if currentIndex < page.data.count {
                let item = page.data[currentIndex]
                currentIndex += 1
                return item
            }

            // Move to next page
            if !page.done, let nextIterator = page.iterator {
                iterator = nextIterator
                currentPage = try await fetchPage(ListOptions(limit: limit, iterator: iterator))
                currentIndex = 0
                return try await next()
            }

            done = true
            return nil
        }
    }
}
