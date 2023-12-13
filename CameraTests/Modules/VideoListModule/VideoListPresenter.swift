import XCTest
@testable import Camera

// Работа VideoListPresenter, когда доступ к камере запрещен
extension CameraTests {
    
    func testPresenterDeniedAccess() async throws {
        // GIVEN
        let mockInteractor = Interactor()
        let mockRouter = Router()
        let presenter = VideoListPresenter(interactor: mockInteractor,  router: mockRouter)
        let mockView = await View()
        presenter.view = mockView
        // WHEN
        await presenter.onTapAddVideoButton()
        // THEN
        let viewShowAlertCallingResult = await mockView.showAlertDidCall
        XCTAssertTrue(viewShowAlertCallingResult)
    }
    
    private final class Interactor: IVideoListInteractor {
        var cameraAccess: CameraAccess {
            .denied
        }
    }
    
    private final class Router: IVideoListRouter {
        func goToMakeVideo() {
            XCTFail("Wrong route logic")
        }
        
        func goToAppSettings() { }
    }
    
    private final class View: UIViewController, IVideoListView {
        var showAlertDidCall = false
        func configureNavigationBar() {}
        
        func showAlert(title: String, message: String, additionalActionTitle: String?, additionalActionHandler: (() -> Void)?) {
            showAlertDidCall = true
        }
    }
}
