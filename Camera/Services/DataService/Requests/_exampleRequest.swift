import Combine

// MARK: - Factory integration

protocol ExampleRequestFactory {
    func _exampleRequest() -> CatFactsRequest
}

extension AppDataRequestFactory: ExampleRequestFactory {
    func _exampleRequest() -> CatFactsRequest {
        CatFactsRequest()
    }
}

// MARK: - Models

// Это объект запроса
struct CatFactsRequestModel: Encodable {}

// Это объект ответа
struct CatFactsResponseModel: Decodable {
    var fact: String
    var length: Int
}

// MARK: - Request

// Это сам запрос
class CatFactsRequest: NetworkService {
    typealias Request = CatFactsRequestModel?
    typealias Response = CatFactsResponseModel

    let baseURL: String = "https://catfact.ninja/"
    let additionalURL: String = "fact"

    func execute(_ request: Request = nil) async throws -> Response {
        try await loadData(withRequest: request, embedding: .jsonToBody)
    }

}
