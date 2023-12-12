import AVFoundation

protocol IVideoListInteractor: ModuleInteractor {
    var navigationBarTitle: String { get }
    var cameraRestrictionLevel: CameraRestrictionLevel { get async }
}

final class VideoListInteractor: IVideoListInteractor {
    private var cameraService: ICameraService
    weak var presenter: IVideoListPresenter?
    
    let navigationBarTitle = String(localized: "Ваши видео")
    
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
