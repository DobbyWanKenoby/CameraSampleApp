protocol IMakeVideoPresenter: ModulePresenter {
    func configureView()
    func onTapCloseButton()
    func onCloseScreen()
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
        Task {
            do {
                let previewLayer = try await interactor.startCaptureSession()
                await MainActor.run {
                    view?.addPreviewLayer(previewLayer)
                }
            } catch {
                debug(.bussinesLogic, message: "Capture session cant be run")
                // TODO: Обработать ошибку
            }
        }
    }
    
    func onTapCloseButton() {
        router.dismiss(controller: view)
    }
    
    func onCloseScreen() {
        Task {
            await interactor.stopCaptureSession()
        }
    }
}
