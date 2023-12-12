import AVFoundation

protocol IVideoListInteractor: ModuleInteractor {
    var cameraRestrictionLevel: CameraRestrictionLevel { get async }
}

final class VideoListInteractor: IVideoListInteractor {
    private var cameraService: ICameraService
    weak var presenter: IVideoListPresenter?
    
    init(cameraService: ICameraService) {
        self.cameraService = cameraService
    }
    
    var cameraRestrictionLevel: CameraRestrictionLevel {
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
