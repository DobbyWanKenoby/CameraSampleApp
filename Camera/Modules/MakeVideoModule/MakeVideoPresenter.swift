// MARK: - Interface

protocol IMakeVideoPresenter: IModulePresenter {
    func configureView() async
    func didTapCloseButton()
    func didTapReverseCameraButton() async
    func onCloseScreen()
}

extension IMakeVideoPresenter {
    func configureView() async {}
    func onTapCloseButton() {}
    func didTapReverseCameraButton() async {}
    func onCloseScreen() {}
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
    
    func configureView() async {
        do {
            guard let previewLayer = try await interactor.startCaptureSession() else {
                return
                // TODO: Заменить на throw с локальной ошибкой
            }
            await view?.updatePreviewLayer(previewLayer)
        } catch {
            debug(.bussinesLogic, message: "Capture session cant be run")
            // TODO: Обработать ошибку
        }
    }
    
    func didTapCloseButton() {
        router.routeBack()
    }
    
    func didTapReverseCameraButton() async {
        do {
            guard let previewLayer = try await interactor.reverseCamera() else { return }
            await view?.updatePreviewLayer(previewLayer)
        } catch {
            // TODO: Обработать ошибку
        }
    }
    
    func onCloseScreen() {
        Task {
            await interactor.stopCaptureSession()
        }
    }
}
