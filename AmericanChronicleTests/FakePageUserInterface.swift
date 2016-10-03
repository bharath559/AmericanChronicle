@testable import AmericanChronicle

class FakePageUserInterface: NSObject, PageUserInterface {

    var doneCallback: ((Void) -> ())?
    var shareCallback: ((Void) -> ())?
    var cancelCallback: ((Void) -> ())?
    var pdfPage: CGPDFPage?
    var highlights: OCRCoordinates?
    var delegate: PageUserInterfaceDelegate?

    var showError_wasCalled_withTitle: String?
    var showError_wasCalled_withMessage: String?
    func showErrorWithTitle(_ title: String?, message: String?) {
        showError_wasCalled_withTitle = title
        showError_wasCalled_withMessage = message
    }

    var showLoadingIndicator_wasCalled = false
    func showLoadingIndicator() {
        showLoadingIndicator_wasCalled = true
    }

    func setDownloadProgress(_ progress: Float) {

    }

    var hideLoadingIndicator_wasCalled = false
    func hideLoadingIndicator() {
        hideLoadingIndicator_wasCalled = true
    }
}
