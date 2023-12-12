protocol IMakeVideoContainer {
    var cameraService: ICameraService { get }
}

final class MakeVideoContainer: IMakeVideoContainer {
    let cameraService: ICameraService
    
    init(cameraService: ICameraService) {
        self.cameraService = cameraService
    }
}
