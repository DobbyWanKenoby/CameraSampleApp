import UIKit

protocol IMakeVideoAssembler {
    func assembly(usingNavigationController navigationController: UINavigationController?) -> UIViewController
}

final class MakeVideoAssembler: IMakeVideoAssembler {
    
    private var diContainer: IMakeVideoContainer
    
    init(diContainer: IMakeVideoContainer) {
        self.diContainer = diContainer
    }
    
    func assembly(usingNavigationController navigationController: UINavigationController? = nil) -> UIViewController {
        let interactor = MakeVideoInteractor(cameraService: diContainer.cameraService)
        let router = MakeVideoRouter()
        
        let presenter = MakeVideoPresenter(interactor: interactor, router: router)
        
        interactor.presenter = presenter
        router.presenter = presenter
        
        let viewController = MakeVideoViewController(presenter: presenter)
        presenter.view = viewController
        
        interactor.presenter = presenter
        
        return viewController
    }
}
