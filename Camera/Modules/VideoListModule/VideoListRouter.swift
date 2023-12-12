import UIKit.UINavigationController
import UIKit.UIApplication

protocol IVideoListRouter: ModuleRouter {
    func goToMakeVideo()
    func goToAppSettings()
}

final class VideoListRouter: IVideoListRouter {
    weak var presenter: IVideoListPresenter? = nil
    weak var navigationController: UINavigationController?
    private let makeVideoAssembler: IMakeVideoAssembler
    
    init(navigationController: UINavigationController?,
         makeVideoAssembler: IMakeVideoAssembler) {
        self.navigationController = navigationController
        self.makeVideoAssembler = makeVideoAssembler
    }
    
    func goToMakeVideo() {
        let view = makeVideoAssembler.assembly(usingNavigationController: navigationController)
        view.modalPresentationStyle = .fullScreen
        navigationController?.present(view, animated: true)
    }
    
    func goToAppSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
