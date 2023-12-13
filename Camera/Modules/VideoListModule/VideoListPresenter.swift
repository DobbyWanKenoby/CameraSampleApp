// MARK: - Interface

protocol IVideoListPresenter: IModulePresenter {
    func configureView()
    func onTapAddVideoButton() async
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
        router.handleEndpointIfNeeded()
        view?.configureNavigationBar()
    }
    
    @MainActor
    func onTapAddVideoButton() async {
        switch await interactor.cameraAccess {
        case .allow:
            router.routeToMakeVideo()
        case .denied:
            view?.showAlert(title: String(localized: "Внимание"),
                            message: String(localized: "Доступ к камере ограничен. Экран создания видео не может быть открыт"),
                            additionalActionTitle: "Перейти к настройкам") { [weak self] in
                self?.router.routeToAppSettings()
            }
        }
    }
}
