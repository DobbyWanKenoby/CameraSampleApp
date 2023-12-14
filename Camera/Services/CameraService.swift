import AVFoundation

// MARK: - Interface

protocol ICameraService {
    var currentAccess: AVAuthorizationStatus { get }
    func requestAccess() async -> Bool
    
    var currentCamera: AVCaptureDevice? { get }
    var currentCameraPosition: CameraPosition { get }
    func setCameraPosition(to: CameraPosition) async throws
    
    /// Настройка сессии захвата данных с камеры
    ///
    /// После использования previewLayer начинает выводить данные с камеры
    ///
    /// - Throws: Ошибка типа CameraServiceError
    func setupSession() async throws
    var previewLayer: AVCaptureVideoPreviewLayer { get }
    /// Завершить сессию захвата данных с камеры
    ///
    /// После использования previewLayer прекращает выводить данные с камеры
    func stopSession()
}

// MARK: - Implementation

final class CameraService: ICameraService {
    private var captureDevice: AVCaptureDevice?
    private var captureSession = AVCaptureSession()
    private var captureInput: AVCaptureInput? = nil
    
    var currentCamera: AVCaptureDevice? = nil
    private(set) var currentCameraPosition: CameraPosition = .back
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var currentAccess: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func setCameraPosition(to newPosition: CameraPosition) async throws {
        currentCameraPosition = newPosition
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        if let captureInput {
            captureSession.removeInput(captureInput)
        }
        
        try await setupSession()
    }
    
    func requestAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func setupSession() async throws {
        debug(.bussinesLogic, message: "Capture session will be run with camera position \(currentCameraPosition)")
        if captureSession.isRunning {
            captureSession.stopRunning()
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
            captureInput = input
        }
//        if captureSession.canAddOutput(cameraOutput) {
//            captureSession.addOutput(cameraOutput)
//        }
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.session = captureSession
        
        debug(.bussinesLogic, message: "Capture session was run")
    }
    
    func stopSession() {
        captureSession.stopRunning()
        debug(.bussinesLogic, message: "Capture session stopped")
    }
    
    
    
}
