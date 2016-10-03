@testable import AmericanChronicle

class FakeSearchDataManager: SearchDataManagerInterface {

    var fetchMoreResults_wasCalled_withParameters: SearchParameters?
    func fetchMoreResults(_ parameters: SearchParameters,
                          completionHandler: @escaping ((SearchResults?, NSError?) -> Void)) {
        fetchMoreResults_wasCalled_withParameters = parameters
    }

    var cancelSearch_wasCalled = false
    var cancelSearch_wasCalled_withParameters: SearchParameters?
    var cancelSearch_wasCalled_withPage: Int?
    func cancelFetch(_ parameters: SearchParameters) {
        cancelSearch_wasCalled = true
        cancelSearch_wasCalled_withParameters = parameters
    }

    var isSearchInProgress_wasCalled = false
    var isSearchInProgress_wasCalled_withParameters: SearchParameters?
    var isSearchInProgress_wasCalled_withPage: Int?
    var isSearchInProgress_stubbedReturnValue = false
    func isFetchInProgress(_ parameters: SearchParameters) -> Bool {
        isSearchInProgress_wasCalled = true
        cancelSearch_wasCalled_withParameters = parameters
        return isSearchInProgress_stubbedReturnValue
    }
}
