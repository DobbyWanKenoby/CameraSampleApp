import UIKit

// MARK: - Interface

protocol IMakeVideoAssembler {
    func assembly() -> UIViewController
}

// MARK: - Implemetation

final class MakeVideoAssembler: IMakeVideoAssembler {
    
    private var diContainer: IMakeVideoDependencyContainer
    
    init(diContainer: IMakeVideoDependencyContainer) {
        self.diContainer = diContainer
    }
    
    func assembly() -> UIViewController {
        let interactor = MakeVideoInteractor(cameraService: diContainer.cameraService)
        let router = MakeVideoRouter(routerService: diContainer.routerService)
        
        let presenter = MakeVideoPresenter(interactor: interactor, router: router)
        
        interactor.presenter = presenter
        router.presenter = presenter
        
        let viewController = MakeVideoViewController(presenter: presenter)
        presenter.view = viewController
        
        interactor.presenter = presenter
        
        return viewController
    }
}
