import Foundation

// MARK: Network Service

/// Протокол, определяющий объект "Сетевой сервис для получения данных"
protocol NetworkService: DataService where Request: Encodable, Response: Decodable {
    var method: RequestMethod { get }
    var baseURL: String { get }
    var additionalURL: String { get }
    var session: URLSession { get }
    var sessionConfiguration: URLSessionConfiguration { get }
}

extension NetworkService {
    var method: RequestMethod { .post }
    var session: URLSession {
        URLSession(configuration: sessionConfiguration)
    }

    var sessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return configuration
    }

    func loadData(withRequest request: Request, embedding: EmbeddingMethod) async throws -> Response {
        var jsonData: Data? = nil
        let queryItems: [URLQueryItem] = []

        switch embedding {
        case .jsonToBody:
            jsonData = try JSONEncoder().encode(request)
        }
        let urlRequest = try constructRequest(
            method,
            baseURL: baseURL,
            additionalURL: additionalURL,
            jsonData: jsonData,
            queryItems: queryItems
        )

        let (data, _) = try await session.data(for: urlRequest)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(Response.self, from: data)

        return decodedData
    }

    private func constructRequest(
        _ method: RequestMethod,
        baseURL _: String,
        additionalURL: String,
        jsonData: Data? = nil,
        queryItems: [URLQueryItem] = [],
        bearerToken _: String? = nil // сейчас не используется
    ) throws -> URLRequest {
        guard var url = URLComponents(string: baseURL + additionalURL) else {
            throw DataServiceError.wrongURL
        }
        url.queryItems = queryItems
        guard let resultURL = url.url else {
            throw DataServiceError.wrongURLQueryItems
        }

        var request = URLRequest(url: resultURL, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = method.rawValue

        if let jsonData {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonData
        }
        info(
            .network,
            message: "Данные для запроса \n URL: \(request), \n JSON: \(String(describing: String(data: jsonData ?? Data(), encoding: .utf8)))"
        )
        return request
    }
}
