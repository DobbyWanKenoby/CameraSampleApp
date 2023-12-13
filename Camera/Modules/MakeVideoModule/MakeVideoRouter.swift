import UIKit

// MARK: - Interface

protocol IMakeVideoRouter: IModuleRouter {
    func dismiss(controller: UIViewController?)
}

// MARK: - Implemetation

final class MakeVideoRouter: IMakeVideoRouter {
    weak var presenter: IMakeVideoPresenter?
    weak var navigationController: UINavigationController?
    
    init() {
        navigationController = nil
        presenter = nil
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        presenter = nil
    }
    
    func dismiss(controller: UIViewController?) {
        controller?.dismiss(animated: true)
    }
}
