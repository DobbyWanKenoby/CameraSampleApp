import UIKit.UINavigationController
import UIKit.UIApplication
import Combine

// MARK: - Interface

protocol IVideoListRouter: IModuleRouter {
    func routeToMakeVideo()
    func routeToAppSettings()
    func handleEndpointIfNeeded()
}

// MARK: - Implemetation

final class VideoListRouter: IVideoListRouter {
    weak var presenter: IVideoListPresenter? = nil
    weak var view: IModuleView? = nil
    
    // Dependencies
    let routerService: IRouterService
    private let makeVideoAssembler: IMakeVideoAssembler
    
    var routerSubscription: AnyCancellable?
    
    init(routerService: IRouterService, makeVideoAssembler: IMakeVideoAssembler) {
        self.routerService = routerService
        self.makeVideoAssembler = makeVideoAssembler
        subscribeOnRouteService()
    }
    
    func routeToMakeVideo() {
        routerService.route(to: .makeVideo)
    }
    
    func routeToAppSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func handleEndpointIfNeeded() {
        forceHandleEndpoint()
    }
}

// MARK: - App Router

extension VideoListRouter: RouteComplitable {
    func route(to endpoint: VideoListEndpoint?) {
        switch endpoint {
        case .videoList:
            view?.presentedViewController?.dismiss(animated: true)
        case .makeVideo:
            let newScreen = makeVideoAssembler.assembly()
            newScreen.modalPresentationStyle = .fullScreen
            self.view?.navigationController?.topViewController?.present(newScreen, animated: true)
        default: return
        }
    }
}

enum VideoListEndpoint: Endpoint {
    case videoList
    case makeVideo
}
