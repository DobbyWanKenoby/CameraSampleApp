import UIKit

protocol ModuleView: UIViewController {}
protocol ModulePresenter: AnyObject {}
protocol ModuleInteractor: AnyObject {}
protocol ModuleRouter: AnyObject {}

extension ModuleView {
    var viewController: UIViewController {
        self
    }
}
