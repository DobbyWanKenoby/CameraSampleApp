import UIKit
import AVFoundation

// MARK: - Interface

@MainActor protocol IMakeVideoView: IModuleView {
    func updatePreviewLayer(_: AVCaptureVideoPreviewLayer)
}

extension IMakeVideoView {
    func updatePreviewLayer(_: AVCaptureVideoPreviewLayer) {}
}

// MARK: - Implementation

final class MakeVideoViewController<Presenter: IMakeVideoPresenter>: UIViewController {
    
    var presenter: IMakeVideoPresenter
    
    private var lastPreviewLayer: CALayer? = nil
    
    private lazy var closeButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.cornerStyle = .medium
        buttonConfiguration.contentInsets = .zero
        
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 30)
        var image = UIImage(systemName:  "xmark.circle.fill", withConfiguration: imageConfiguration)
        buttonConfiguration.image = image
        buttonConfiguration.baseForegroundColor = .white.withAlphaComponent(0.7)
        
        let button = UIButton(configuration: buttonConfiguration)
        button.addAction(UIAction { [self] _ in
            self.presenter.didTapCloseButton()
        }, for: .primaryActionTriggered)
        
        button.tintColor = .black.withAlphaComponent(0.7)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var reverseCameraButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.cornerStyle = .medium
        buttonConfiguration.contentInsets = .zero
        
        var imageConfiguration = UIImage.SymbolConfiguration(pointSize: 30)
        var image = UIImage(systemName:  "arrow.up.arrow.down.circle.fill", withConfiguration: imageConfiguration)
        buttonConfiguration.image = image
        buttonConfiguration.baseForegroundColor = .white.withAlphaComponent(0.7)
        
        let button = UIButton(configuration: buttonConfiguration)
        button.addAction(UIAction { [self] _ in
            Task {
                await self.presenter.didTapReverseCameraButton()
            }
        }, for: .primaryActionTriggered)
        
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
        
        Task.detached {
            await self.presenter.configureView()
        }
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
        
        view.addSubview(reverseCameraButton)
        NSLayoutConstraint.activate([
            reverseCameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            reverseCameraButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)
        ])
        
    }
}

extension MakeVideoViewController: IMakeVideoView {
    func updatePreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        lastPreviewLayer?.removeFromSuperlayer()
        view.layer.insertSublayer(layer, at: 0)
        layer.frame = view.bounds
        lastPreviewLayer = layer
    }
}
