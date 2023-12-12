import UIKit

protocol IVideoListView: ModuleView {
    func configureNavigationBar(withTitle: String)
    func showAlert(title: String, message: String, additionalActionTitle: String?, additionalActionHandler: (() -> Void)?)
}

final class VideoListViewController: UIViewController, IVideoListView {
    
    var presenter: IVideoListPresenter
    
    init(presenter: IVideoListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        presenter.configureView()
    }
    
    func configureNavigationBar(withTitle title: String) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
        let action = UIAction { [self] _ in
            self.presenter.onTapAddVideoButton()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    func showAlert(title: String, message: String, additionalActionTitle: String?, additionalActionHandler: (() -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: String(localized: "OK"), style: .default) { _ in }
        controller.addAction(action)
        if let additionalActionTitle {
            let _action = UIAlertAction(title: additionalActionTitle, style: .default) { _ in additionalActionHandler?() }
            controller.addAction(_action)
        }
        self.present(controller, animated: true)
    }
    
}
