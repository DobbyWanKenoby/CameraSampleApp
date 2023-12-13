// MARK: - Interface

protocol IVideoListDependencyContainer {
    var cameraService: ICameraService { get }
    var makeVideoAssembler: IMakeVideoAssembler { get }
}

// MARK: - Implemetation

final class VideoListContainer: IVideoListDependencyContainer {
    let cameraService: ICameraService
    let makeVideoAssembler: IMakeVideoAssembler
    
    init(cameraService: ICameraService, makeVideoAssembler: IMakeVideoAssembler) {
        self.cameraService = cameraService
        self.makeVideoAssembler = makeVideoAssembler
    }
}
