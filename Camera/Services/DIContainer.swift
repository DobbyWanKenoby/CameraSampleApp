protocol IDIContainer: AnyObject {
    var cameraService: ICameraService { get }
    var routeService: IRouterService { get }
}

final class DIContainer: IDIContainer {
    let cameraService: ICameraService
    let routeService: IRouterService
    
    init(cameraService: ICameraService, routeService: IRouterService) {
        self.cameraService = cameraService
        self.routeService = routeService
    }
}

