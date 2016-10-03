import XCTest
@testable import AmericanChronicle

class DelayedSearchTests: XCTestCase {
    var subject: DelayedSearch!
    var runLoop: FakeRunLoop!
    var dataManager: FakeSearchDataManager!
    var completionHandlerExpectation: XCTestExpectation?
    var results: SearchResults?
    var error: NSError?

    override func setUp() {
        super.setUp()
        runLoop = FakeRunLoop()
        dataManager = FakeSearchDataManager()

        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject = DelayedSearch(parameters: params, dataManager: dataManager, runLoop: runLoop, completionHandler: { results, error in
            self.results = results
            self.error = error as? NSError
            self.completionHandlerExpectation?.fulfill()
        })
    }

    func testThat_itStartsItsTimerImmediately() {
        XCTAssert(runLoop.addTimer_wasCalled_withTimer?.isValid ?? false)
    }

    func testThat_beforeTheTimerHasFired_cancel_invalidatesTheTimer() {
        subject.cancel()
        XCTAssertFalse(runLoop.addTimer_wasCalled_withTimer?.isValid ?? true)
    }

    func testThat_beforeTheTimerHasFired_cancel_triggersTheCompletionHandler_withACancelledError() {
        subject.cancel()
        XCTAssertEqual(error?.code, -999)
    }

    func testThat_afterTheTimerHasFired_cancel_callsCancelOnTheDataManager() {
        runLoop.addTimer_wasCalled_withTimer?.fire()
        subject.cancel()
        XCTAssert(dataManager.cancelSearch_wasCalled)
    }

    func testThat_beforeTheTimerHasFired_isSearchInProgress_returnsTrue() {
        XCTAssert(subject.isSearchInProgress())
    }

    func testThat_afterTheTimerHasFired_isSearchInProgress_returnsTheValueReturnedByTheDataManager() {
        runLoop.addTimer_wasCalled_withTimer?.fire()
        dataManager.isSearchInProgress_stubbedReturnValue = true
        XCTAssert(subject.isSearchInProgress())
        dataManager.isSearchInProgress_stubbedReturnValue = false
        XCTAssertFalse(subject.isSearchInProgress())
    }

    func testThat_whenTheTimerFires_itStartsSearchOnTheDataManager_withTheCorrectParameters() {
        runLoop.addTimer_wasCalled_withTimer?.fire()
        let expectedParameters = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
            latestDayMonthYear: Search.latestPossibleDayMonthYear
        )
        XCTAssertEqual(dataManager.fetchMoreResults_wasCalled_withParameters, expectedParameters)
    }
}
