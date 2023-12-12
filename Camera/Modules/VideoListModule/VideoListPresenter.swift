protocol IVideoListPresenter: ModulePresenter {
    func configureView()
    func onTapAddVideoButton()
}

enum VideoListDestination {
    case makeVideo
}

final class VideoListPresenter: IVideoListPresenter {
    let router: IVideoListRouter
    let interactor: IVideoListInteractor
    weak var view: IVideoListView?
    
    init(interactor: IVideoListInteractor, router: IVideoListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func configureView() {
        view?.configureNavigationBar(withTitle: interactor.navigationBarTitle)
    }
    
    func onTapAddVideoButton() {
        Task { @MainActor in
            switch await interactor.cameraRestrictionLevel {
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
    }
    
    private func go(to destination: VideoListDestination) {
        switch destination {
        case .makeVideo:
            router.goToMakeVideo()
        }
    }
}
