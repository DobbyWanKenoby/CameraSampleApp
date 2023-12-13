import AVFoundation

// MARK: - Interface

protocol IVideoListInteractor: IModuleInteractor {
    var cameraAccess: CameraAccess { get async }
}

extension IVideoListInteractor {}

// MARK: - Implemetation

final class VideoListInteractor: IVideoListInteractor {
    private var cameraService: ICameraService
    weak var presenter: IVideoListPresenter?
    
    init(cameraService: ICameraService) {
        self.cameraService = cameraService
    }
    
    var cameraAccess: CameraAccess {
        get async {
            switch cameraService.currentAccess {
            case .notDetermined: await cameraService.requestAccess() ? .allow : .denied
            case .restricted:.denied
            case .denied:.denied
            case .authorized:.allow
            @unknown default: .denied
            }
        }
    }

}
