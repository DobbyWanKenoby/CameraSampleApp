protocol IDIContainer: AnyObject {
    var cameraService: ICameraService { get }
}

final class DIContainer: IDIContainer {
    let cameraService: ICameraService
    
    init(cameraService: ICameraService) {
        self.cameraService = cameraService
    }
}

