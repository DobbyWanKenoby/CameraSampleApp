import AVFoundation

protocol IMakeVideoInteractor: ModuleInteractor {
    init(cameraService: ICameraService)
    func startCaptureSession() throws -> AVCaptureVideoPreviewLayer
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
    
    func startCaptureSession() throws -> AVCaptureVideoPreviewLayer {
        try cameraService.setupSession()
        return cameraService.previewLayer
    }

}
