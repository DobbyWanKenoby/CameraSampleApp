import UIKit

// MARK: - Interface

protocol IVideoListAssembler {
    func assembly() -> UIViewController
}

// MARK: - Implemetation

final class VideoListAssembler: IVideoListAssembler {

    private let serviceLocator: IVideoListServiceLocator
    
    init(serviceLocator: IVideoListServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    func assembly() -> UIViewController {
        let interactor = VideoListInteractor(cameraService: serviceLocator.cameraService)
        let router = VideoListRouter(routerService: serviceLocator.routeService,
                                     makeVideoAssembler: serviceLocator.makeVideoAssembler)
        
        let presenter = VideoListPresenter(interactor: interactor, router: router)
        
        interactor.presenter = presenter
        router.presenter = presenter
        
        let viewController = VideoListViewController(presenter: presenter)
        presenter.view = viewController
        router.view = viewController
        
        interactor.presenter = presenter
        
        return viewController
    }
}
