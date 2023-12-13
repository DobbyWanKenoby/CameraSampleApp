import Foundation

enum CameraServiceError: LocalizedError {
    case errorDuringCreationCaptureSession
    case errorDuringCreateDeviceInput
    
    var errorDescription: String? {
        switch self {
        case .errorDuringCreationCaptureSession:
            "Can not create new AVCaptureSession"
        case .errorDuringCreateDeviceInput:
            "Something was wrong during creations of AVCaptureDeviceInput from AVCaptureDevice"
        }
    }
}
