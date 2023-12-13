// MARK: - Interface

protocol IMakeVideoDependencyContainer {
    var cameraService: ICameraService { get }
}

// MARK: - Implemetation

final class MakeVideoContainer: IMakeVideoDependencyContainer {
    let cameraService: ICameraService
    
    init(cameraService: ICameraService) {
        self.cameraService = cameraService
    }
}
