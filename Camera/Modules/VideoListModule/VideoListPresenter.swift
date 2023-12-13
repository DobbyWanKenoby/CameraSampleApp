// MARK: - Interface

protocol IVideoListPresenter: IModulePresenter {
    func configureView()
    func onTapAddVideoButton() async
}

enum VideoListDestination {
    case makeVideo
}

// MARK: - Implemetation

final class VideoListPresenter<Interactor: IVideoListInteractor, Router: IVideoListRouter>: IVideoListPresenter {
    let router: Router
    let interactor: Interactor
    weak var view: (any IVideoListView)?
    
    init(interactor: Interactor, router: Router) {
        self.interactor = interactor
        self.router = router
    }
    
    func configureView() {
        view?.configureNavigationBar()
    }
    
    @MainActor
    func onTapAddVideoButton() async {
        switch await interactor.cameraAccess {
        case .allow:
            go(to: .makeVideo)
        case .denied:
            view?.showAlert(title: String(localized: "Внимание"),
                            message: String(localized: "Доступ к камере ограничен. Экран создания видео не может быть открыт"),
                            additionalActionTitle: "Перейти к настройкам") { [weak self] in
                self?.router.goToAppSettings()
            }
        }
    }
    
    private func go(to destination: VideoListDestination) {
        switch destination {
        case .makeVideo:
            router.goToMakeVideo()
        }
    }
}
