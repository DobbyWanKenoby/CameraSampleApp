import UIKit

// MARK: - Interface

protocol IMakeVideoAssembler {
    func assembly() -> UIViewController
}

// MARK: - Implemetation

final class MakeVideoAssembler: IMakeVideoAssembler {
    
    private var serviceLocator: IMakeVideoServiceLocator
    
    init(serviceLocator: IMakeVideoServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    func assembly() -> UIViewController {
        let interactor = MakeVideoInteractor(cameraService: serviceLocator.cameraService)
        let router = MakeVideoRouter(routerService: serviceLocator.routerService)
        
        let presenter = MakeVideoPresenter(interactor: interactor, router: router)
        
        interactor.presenter = presenter
        router.presenter = presenter
        
        let viewController = MakeVideoViewController(presenter: presenter)
        presenter.view = viewController
        
        interactor.presenter = presenter
        
        return viewController
    }
}
