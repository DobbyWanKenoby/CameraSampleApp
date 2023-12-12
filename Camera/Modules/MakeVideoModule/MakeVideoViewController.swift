import UIKit
import AVFoundation

protocol IMakeVideoView: ModuleView {
    func addPreviewLayer(_: AVCaptureVideoPreviewLayer)
}

final class MakeVideoViewController: UIViewController, IMakeVideoView {
    
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
    
    var presenter: IMakeVideoPresenter
    
    init(presenter: IMakeVideoPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        presenter.configureView()
        layoutElements()
    }
    
    private func layoutElements() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
        
    }
    
    func addPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        view.layer.addSublayer(layer)
        layer.frame = view.bounds
    }
}

final class PrevieweView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

//#Preview {
//    MakeVideoViewController(presenter: MakeVideoPresenter(interactor: MakeVideoInteractor(di: DependencyContainer()), router: MakeVideoRouter()))
//}
