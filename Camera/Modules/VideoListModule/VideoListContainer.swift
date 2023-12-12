protocol IVideoListContainer {
    var cameraService: ICameraService { get }
    var makeVideoAssembler: IMakeVideoAssembler { get }
}

final class VideoListContainer: IVideoListContainer {
    let cameraService: ICameraService
    let makeVideoAssembler: IMakeVideoAssembler
    
    init(cameraService: ICameraService, makeVideoAssembler: IMakeVideoAssembler) {
        self.cameraService = cameraService
        self.makeVideoAssembler = makeVideoAssembler
    }
}
