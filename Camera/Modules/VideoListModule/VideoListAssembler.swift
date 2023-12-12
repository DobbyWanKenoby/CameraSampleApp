import UIKit

protocol IVideoListAssembler {
    func assembly(usingNavigationController navigationController: UINavigationController?) -> UIViewController
}

final class VideoListAssembler: IVideoListAssembler {

    private let diContainer: IVideoListContainer
    
    init(diContainer: IVideoListContainer) {
        self.diContainer = diContainer
    }
    
    func assembly(usingNavigationController navigationController: UINavigationController?) -> UIViewController {
        let interactor = VideoListInteractor(cameraService: diContainer.cameraService)
        let router = VideoListRouter(navigationController: navigationController,
                                     makeVideoAssembler: diContainer.makeVideoAssembler)
        
        let presenter = VideoListPresenter(interactor: interactor, router: router)
        
        interactor.presenter = presenter
        router.presenter = presenter
        
        let viewController = VideoListViewController(presenter: presenter)
        presenter.view = viewController
        
        interactor.presenter = presenter
        
        return viewController
    }
}
