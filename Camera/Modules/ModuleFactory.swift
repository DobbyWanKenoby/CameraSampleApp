protocol IModuleFactory: AnyObject {}

final class ModuleFactory {
    let diContainer: IDIContainer
    init(diContainer: IDIContainer) {
        self.diContainer = diContainer
    }
    
    var videoListAssembler: IVideoListAssembler {
        let container = VideoListContainer(
            routeService: diContainer.routeService,
            cameraService: diContainer.cameraService,
            makeVideoAssembler: self.makeVideoAssembler)
        return VideoListAssembler(diContainer: container)
    }
    
    var makeVideoAssembler: IMakeVideoAssembler {
        let container = MakeVideoContainer(routerService: diContainer.routeService,
                                           cameraService: diContainer.cameraService)
        return MakeVideoAssembler(diContainer: container)
    }
}
