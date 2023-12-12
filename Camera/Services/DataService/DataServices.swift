import Combine
import Foundation

// MARK: - Base protocol

/// Протокол, определяющий объект "Сервис для получения данных"
protocol DataService {
    associatedtype Request
    associatedtype Response
    func loadData(withRequest request: Request, embedding: EmbeddingMethod) async throws -> Response
}

/// Указывает, куда и как встраивать переданную модель запроса
enum EmbeddingMethod {
    case jsonToBody
    // TODO: Релизовать кастомный Encoder, если потребуется встраивать модель в url в виде query params
    // case itemsToQuery
}

/// Тип запроса
enum RequestMethod: String {
    case get
    case post
}
