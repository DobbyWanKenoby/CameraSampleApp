protocol IMakeVideoPresenter: ModulePresenter {
    func configureView()
    func onTapCloseButton()
}

final class MakeVideoPresenter: IMakeVideoPresenter {
    
    let router: IMakeVideoRouter
    let interactor: IMakeVideoInteractor
    weak var view: IMakeVideoView?
    
    init(interactor: IMakeVideoInteractor, router: IMakeVideoRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func configureView() {
        do {
            let previewLayer = try interactor.startCaptureSession()
            view?.addPreviewLayer(previewLayer)
        } catch {
            // TODO: Обработать ошибку
        }
    }
    
    func onTapCloseButton() {
        router.dismiss(controller: view)
    }
}
