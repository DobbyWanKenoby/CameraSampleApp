import UIKit

protocol IModuleView: UIViewController {}
protocol IModulePresenter: AnyObject {}
protocol IModuleInteractor: AnyObject {}
protocol IModuleRouter: AnyObject {}

extension IModuleView {
    var viewController: UIViewController {
        self
    }
}
