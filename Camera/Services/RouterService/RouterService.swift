import Combine
import Foundation

// Рутовый экндпоинт
// Должен быть известен на уровне протокола во время компиляции
typealias RootEndpoint = VideoListEndpoint

// MARK: - Interfaces

protocol IRouterService {
    var endpoint: Endpoint? { get }
    var endpointPublisher: AnyPublisher<Endpoint, Never> { get }
    func route(to: RootEndpoint)
    func targetDidReached(nextEndpoint: Endpoint?)
}
protocol Endpoint {}

protocol RouteComplitable: AnyObject {
    associatedtype ModuleEndpoint: Endpoint
    var routerService: IRouterService { get }
    var routerSubscription: AnyCancellable? { get set }
    func route(to: ModuleEndpoint?)
    func handleEndpointIfCan(deeplink: Endpoint?)
}

extension RouteComplitable {
    func handleEndpointIfCan(deeplink: Endpoint?) {
        guard let moduleDeeplink = deeplink as? ModuleEndpoint else {
            return
        }
        route(to: moduleDeeplink)
    }
    
    func subscribeOnRouteService() {
        debug(.routing, message: "\(String(reflecting: Self.self)) подписка на роутинг")

        routerSubscription = routerService.endpointPublisher
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { endpoint in
                debug(.routing, message: "\(String(reflecting: Self.self)) в подписке обрабатывает эндпоинт - \(endpoint)")
            })
            .sink { endpoint in
                self.handleEndpointIfCan(deeplink: endpoint)
            }
    }
    
    func forceHandleEndpoint() {
        guard let endpoint = routerService.endpoint else { return }
        debug(.routing, message: "\(String(reflecting: Self.self)) принудительно обрабатывает эндпоинт - \(endpoint)")
        self.handleEndpointIfCan(deeplink: endpoint)
    }
}

// MARK: - Implementation

final class RouterService: IRouterService {
    var endpoint: Endpoint? = nil
    var endpointPublisher: AnyPublisher<Endpoint, Never> {
        localPublisher.eraseToAnyPublisher()
    }
    private(set) var localPublisher = PassthroughSubject<Endpoint, Never>()
    
    func route(to endpoint: RootEndpoint) {
        self.endpoint = endpoint
        localPublisher.send(endpoint)
    }
    
    func targetDidReached(nextEndpoint: Endpoint?) {
        if let next = nextEndpoint {
            endpoint = next
            localPublisher.send(next)
        } else {
            endpoint = nil
        }
    }
}
