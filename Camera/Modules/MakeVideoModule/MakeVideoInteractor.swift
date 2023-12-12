import AVFoundation

protocol IMakeVideoInteractor: ModuleInteractor {
    init(cameraService: ICameraService)
    func startCaptureSession() async throws -> AVCaptureVideoPreviewLayer
    func stopCaptureSession() async
}

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
