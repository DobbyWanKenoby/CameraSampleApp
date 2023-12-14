protocol IModuleFactory: AnyObject {}

final class ModuleFactory {
    let serviceLocator: IGlobalServiceLocator
    init(serviceLocator: IGlobalServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    var videoListAssembler: IVideoListAssembler {
        let container = VideoListServiceLocator(
            routeService: serviceLocator.routeService,
            cameraService: serviceLocator.cameraService,
            makeVideoAssembler: self.makeVideoAssembler)
        return VideoListAssembler(serviceLocator: container)
    }
    
    var makeVideoAssembler: IMakeVideoAssembler {
        let container = MakeVideoServiceLocator(routerService: serviceLocator.routeService,
                                           cameraService: serviceLocator.cameraService)
        return MakeVideoAssembler(serviceLocator: container)
    }
}
