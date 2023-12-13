import UIKit

// MARK: - Interface

protocol IVideoListAssembler {
    func assembly() -> UIViewController
}

// MARK: - Implemetation

final class VideoListAssembler: IVideoListAssembler {

    private let diContainer: IVideoListDependencyContainer
    
    init(diContainer: IVideoListDependencyContainer) {
        self.diContainer = diContainer
    }
    
    func assembly() -> UIViewController {
        let interactor = VideoListInteractor(cameraService: diContainer.cameraService)
        let router = VideoListRouter(makeVideoAssembler: diContainer.makeVideoAssembler)
        
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
