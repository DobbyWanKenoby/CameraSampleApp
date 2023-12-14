protocol IGlobalServiceLocator: AnyObject {
    var cameraService: ICameraService { get }
    var routeService: IRouterService { get }
}

final class GlobalServiceLocator: IGlobalServiceLocator {
    let cameraService: ICameraService
    let routeService: IRouterService
    
    init(cameraService: ICameraService, routeService: IRouterService) {
        self.cameraService = cameraService
        self.routeService = routeService
    }
}

