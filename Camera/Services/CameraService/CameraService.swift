import AVFoundation

protocol ICameraService {
    var currentAccess: AVAuthorizationStatus { get }
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    func requestAccess() async -> Bool
    func setupSession() throws
}

final class CameraService: ICameraService {
    private var captureDevice: AVCaptureDevice?
    
    let captureSession = AVCaptureSession()
    let cameraOutput = AVCaptureVideoDataOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    var currentAccess: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func requestAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func setupSession() throws {
        captureSession.beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        let input = try AVCaptureDeviceInput(device: videoDevice)
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        if captureSession.canAddOutput(cameraOutput) {
            captureSession.addOutput(cameraOutput)
        }
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = captureSession
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    func captureVideo() {
        
    }
}
