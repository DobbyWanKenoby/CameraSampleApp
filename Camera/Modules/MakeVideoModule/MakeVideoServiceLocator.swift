// MARK: - Interface

protocol IMakeVideoServiceLocator {
    var routerService: IRouterService { get }
    var cameraService: ICameraService { get }
}

// MARK: - Implemetation

final class MakeVideoServiceLocator: IMakeVideoServiceLocator {
    var routerService: IRouterService
    let cameraService: ICameraService
    
    init(routerService: IRouterService, cameraService: ICameraService) {
        self.routerService = routerService
        self.cameraService = cameraService
    }
}
