import UIKit.UIViewController
import Combine

// MARK: - Interface

protocol IMakeVideoRouter: IModuleRouter {
    func routeBack()
}

extension IMakeVideoRouter {
    func routeBack() {}
}

// MARK: - Implemetation

final class MakeVideoRouter: IMakeVideoRouter {
    weak var presenter: IMakeVideoPresenter? = nil
    var routerSubscription: AnyCancellable?
    
    // Dependencies
    let routerService: IRouterService
    
    init(routerService: IRouterService) {
        self.routerService = routerService
    }
    
    func routeBack() {
        routerService.route(to: .videoList)
    }
}

// MARK: - App Router

enum MakeVideoEndpoint: Endpoint {
    case cameraPreview
}

extension MakeVideoRouter: RouteComplitable {
    func route(to endpoint: MakeVideoEndpoint?) {
        switch endpoint {
        case .cameraPreview: return
        default: return
        }
    }
}

