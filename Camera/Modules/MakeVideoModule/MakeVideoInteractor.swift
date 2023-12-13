import AVFoundation

// MARK: - Interface

protocol IMakeVideoInteractor: IModuleInteractor {
    init(cameraService: ICameraService)
    func startCaptureSession() async throws -> AVCaptureVideoPreviewLayer
    func stopCaptureSession() async
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
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer {
        cameraService.previewLayer
    }
    
    init(cameraService: ICameraService) {
        self.cameraService = cameraService
    }
    
    func startCaptureSession() async throws -> AVCaptureVideoPreviewLayer {
        try cameraService.setupSession()
        return cameraService.previewLayer
    }
    
    func stopCaptureSession() async {
        cameraService.stopSession()
    }

}
