import UIKit.UINavigationController
import UIKit.UIApplication

// MARK: - Interface

protocol IVideoListRouter: IModuleRouter {
    func goToMakeVideo()
    func goToAppSettings()
}

// MARK: - Implemetation

final class VideoListRouter: IVideoListRouter {
    weak var presenter: IVideoListPresenter? = nil
    weak var view: IModuleView? = nil
    private let makeVideoAssembler: IMakeVideoAssembler
    
    init(makeVideoAssembler: IMakeVideoAssembler) {
        self.makeVideoAssembler = makeVideoAssembler
    }
    
    func goToMakeVideo() {
        let newScreen = makeVideoAssembler.assembly()
        newScreen.modalPresentationStyle = .fullScreen
        self.view?.navigationController?.topViewController?.present(newScreen, animated: true)
    }
    
    func goToAppSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
