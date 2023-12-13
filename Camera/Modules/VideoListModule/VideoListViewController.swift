import UIKit

// MARK: - Interface

protocol IVideoListView: IModuleView {
    func configureNavigationBar()
    func showAlert(title: String, message: String, additionalActionTitle: String?, additionalActionHandler: (() -> Void)?)
}

extension IVideoListView {
    func configureNavigationBar() {}
    func showAlert(title: String, message: String, additionalActionTitle: String?, additionalActionHandler: (() -> Void)?) {}
}

// MARK: - Implemetation

final class VideoListViewController<Presenter: IVideoListPresenter> : UIViewController {
    private var presenter: Presenter
    
    init(presenter: Presenter) {
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
}

extension VideoListViewController: IVideoListView {
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = String(localized: "Ваши видео")
        let action = UIAction { [self] _ in
            Task {
                await self.presenter.onTapAddVideoButton()
            }
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
