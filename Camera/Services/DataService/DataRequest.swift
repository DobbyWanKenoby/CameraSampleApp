import Combine

/// Протокол, определяющий объект "Запрос к данным"
protocol DataRequest {
    associatedtype Input
    associatedtype Output
    func execute(_: Input) async throws -> Output
}
