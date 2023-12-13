// MARK: - Interface

protocol IMakeVideoPresenter: IModulePresenter {
    func configureView()
    func onTapCloseButton()
    func onCloseScreen()
}

// MARK: - Implemetation

final class MakeVideoPresenter<Interactor: IMakeVideoInteractor, Router: IMakeVideoRouter>: IMakeVideoPresenter {
    let router: Router
    let interactor: Interactor
    weak var view: IMakeVideoView?
    
    init(interactor: Interactor, router: Router) {
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
