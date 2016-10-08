@testable import AmericanChronicle

final class FakePageWireframe: PageWireframeInterface {

    // mark: Test stuff

    var dismissPageScreen_wasCalled = false

    // mark: PageWireframeInterface conformance

    init(delegate: PageWireframeDelegate, presenter: PagePresenterInterface = PagePresenter()) {}

    func present(fromViewController presentingViewController: UIViewController?,
                 withSearchTerm searchTerm: String?,
                 remoteURL: URL,
                 id: String) {

    }

    func showShareScreen(withImage image: UIImage?) {}

    func dismissPageScreen() {
        dismissPageScreen_wasCalled = true
    }
}
