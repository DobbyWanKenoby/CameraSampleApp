import AVFoundation

// MARK: - Interface

protocol IMakeVideoInteractor: IModuleInteractor {
    init(cameraService: ICameraService)
    func startCaptureSession() async throws -> AVCaptureVideoPreviewLayer?
    func stopCaptureSession() async
    func reverseCamera() async throws -> AVCaptureVideoPreviewLayer?
}

extension IMakeVideoInteractor {
    func startCaptureSession() async throws -> AVCaptureVideoPreviewLayer {
        .init()
    }
    func stopCaptureSession() async {}
}

// MARK: - Implemetation

final class MakeVideoInteractor: IMakeVideoInteractor {
    private var cameraService: ICameraService
    weak var presenter: IMakeVideoPresenter? = nil
    
    init(cameraService: ICameraService) {
        self.cameraService = cameraService
    }
    
    func startCaptureSession() async throws -> AVCaptureVideoPreviewLayer? {
        try await cameraService.setupSession()
    }
    
    func stopCaptureSession() async {
        cameraService.stopSession()
    }
    
    func reverseCamera() async throws -> AVCaptureVideoPreviewLayer? {
        return try await cameraService.setCameraPosition(to: cameraService.currentCameraPosition.next)
    }

}
