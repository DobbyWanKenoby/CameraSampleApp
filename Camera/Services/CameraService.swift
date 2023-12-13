import AVFoundation

// MARK: - Interface

protocol ICameraService {
    var currentAccess: AVAuthorizationStatus { get }
    var currentCameraPosition: CameraPosition { get }
    func setCameraPosition(to: CameraPosition) async throws -> AVCaptureVideoPreviewLayer?
    var currentCamera: AVCaptureDevice? { get }
    func requestAccess() async -> Bool
    /// Настройка сессии захвата данных с камеры
    ///
    /// После использования previewLayer начинает выводить данные с камеры
    ///
    /// - Throws: Ошибка типа CameraServiceError
    func setupSession() async throws -> AVCaptureVideoPreviewLayer
    /// Завершить сессию захвата данных с камеры
    ///
    /// После использования previewLayer прекращает выводить данные с камеры
    func stopSession()
}

// MARK: - Implementation

final class CameraService: ICameraService {
    private var captureDevice: AVCaptureDevice?
    
    private var captureSession: AVCaptureSession? = nil
//    let cameraOutput = AVCaptureVideoDataOutput()
    
    var currentCamera: AVCaptureDevice? = nil
    private(set) var currentCameraPosition: CameraPosition = .back
    
    var currentAccess: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func setCameraPosition(to newPosition: CameraPosition) async throws -> AVCaptureVideoPreviewLayer? {
        currentCameraPosition = newPosition
        if let session = captureSession, session.isRunning {
            session.stopRunning()
        }
        return try await setupSession()
    }
    
    func requestAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func setupSession() async throws -> AVCaptureVideoPreviewLayer {
        debug(.bussinesLogic, message: "Capture session will be run with camera position \(currentCameraPosition)")
        if let captureSession, captureSession.isRunning {
            captureSession.stopRunning()
            self.captureSession = nil
        }
        captureSession = AVCaptureSession()
        guard let captureSession else {
            debug(.bussinesLogic, message: "Capture session can not be created")
            throw CameraServiceError.errorDuringCreationCaptureSession
        }
        captureSession.beginConfiguration()
        
        currentCamera = switch currentCameraPosition {
        case .front:
            AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        case .back:
            AVCaptureDevice.default(.builtInTripleCamera, for: .video, position: .back)
        }
        guard let camera = currentCamera else {
            captureSession.commitConfiguration()
            captureSession.stopRunning()
            throw CameraServiceError.errorDuringCreateDeviceInput
        }
        let input = try AVCaptureDeviceInput(device: camera)
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
//        if captureSession.canAddOutput(cameraOutput) {
//            captureSession.addOutput(cameraOutput)
//        }
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = captureSession
        captureSession.commitConfiguration()
        captureSession.startRunning()
        debug(.bussinesLogic, message: "Capture session was run")
        return previewLayer
    }
    
    func stopSession() {
        captureSession?.stopRunning()
        debug(.bussinesLogic, message: "Capture session stopped")
    }
    
    
    
}
