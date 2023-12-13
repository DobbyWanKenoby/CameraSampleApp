import UIKit
import AVFoundation

// MARK: - Interface

protocol IMakeVideoView: IModuleView {
    func addPreviewLayer(_: AVCaptureVideoPreviewLayer)
}

extension IMakeVideoView {
    func addPreviewLayer(_: AVCaptureVideoPreviewLayer) {}
}

// MARK: - Implementation

final class MakeVideoViewController<Presenter: IMakeVideoPresenter>: UIViewController {
    
    var presenter: IMakeVideoPresenter
    
    private lazy var closeButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.cornerStyle = .medium
        buttonConfiguration.contentInsets = .zero
        
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 30)
        var image = UIImage(systemName:  "xmark.circle.fill", withConfiguration: imageConfiguration)
        buttonConfiguration.image = image
        
        let button = UIButton(configuration: buttonConfiguration)
        button.addAction(UIAction { [self] _ in self.presenter.onTapCloseButton() }, for: .primaryActionTriggered)
        
        button.tintColor = .black.withAlphaComponent(0.7)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        presenter.configureView()
        layoutElements()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.onCloseScreen()
    }
    
    private func layoutElements() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
        
    }
}

extension MakeVideoViewController: IMakeVideoView {
    func addPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        view.layer.insertSublayer(layer, at: 0)
        layer.frame = view.bounds
    }
}

//#Preview {
//    MakeVideoViewController(presenter: MakeVideoPresenter(interactor: MakeVideoInteractor(di: DependencyContainer()), router: MakeVideoRouter()))
//}
