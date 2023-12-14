// MARK: - Interface

protocol IVideoListServiceLocator {
    var routeService: IRouterService { get }
    var cameraService: ICameraService { get }
    var makeVideoAssembler: IMakeVideoAssembler { get }
}

// MARK: - Implemetation

final class VideoListServiceLocator: IVideoListServiceLocator {
    let routeService: IRouterService
    let cameraService: ICameraService
    let makeVideoAssembler: IMakeVideoAssembler
    
    init(routeService: IRouterService, cameraService: ICameraService, makeVideoAssembler: IMakeVideoAssembler) {
        self.routeService = routeService
        self.cameraService = cameraService
        self.makeVideoAssembler = makeVideoAssembler
    }
}
