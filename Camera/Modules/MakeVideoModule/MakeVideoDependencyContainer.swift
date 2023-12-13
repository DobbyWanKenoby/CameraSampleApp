// MARK: - Interface

protocol IMakeVideoDependencyContainer {
    var routerService: IRouterService { get }
    var cameraService: ICameraService { get }
}

// MARK: - Implemetation

final class MakeVideoContainer: IMakeVideoDependencyContainer {
    var routerService: IRouterService
    let cameraService: ICameraService
    
    init(routerService: IRouterService, cameraService: ICameraService) {
        self.routerService = routerService
        self.cameraService = cameraService
    }
}
