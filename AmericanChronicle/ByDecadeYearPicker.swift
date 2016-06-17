final class ByDecadeYearPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: Properties

    private static let decadeTransitionScrollArea: CGFloat = 100.0
    private static let headerReuseIdentifier = "Header"

    var earliestYear: Int? {
        didSet { updateYearsAndDecades() }
    }
    var latestYear: Int? {
        didSet { updateYearsAndDecades() }
    }
    var selectedYear: Int? {
        didSet {
            if let year = selectedYear {
                let decadeString = "\(year/10)0s"
                if let section = decades.indexOf(decadeString),
                    item = yearsByDecade[decadeString]?.indexOf("\(year)") {
                    let path = NSIndexPath(forItem: item, inSection: section)
                    yearCollectionView.selectItemAtIndexPath(path,
                                                             animated: true,
                                                             scrollPosition: .None)
                    return
                }
            }
            yearCollectionView.selectItemAtIndexPath(nil, animated: false, scrollPosition: .Top)
        }
    }
    var yearTapHandler: ((String) -> Void)?

    private let decadeStrip: VerticalStrip
    private let yearCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.whiteColor()//Colors.lightBlueBrightTransparent
        view.bounces = false
        view.registerClass(ByDecadeYearPickerCell.self,
                          forCellWithReuseIdentifier: NSStringFromClass(ByDecadeYearPickerCell.self))
        view.registerClass(UICollectionReusableView.self,
                           forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                           withReuseIdentifier: "Header")
        return view
    }()
    private var yearsByDecade: [String: [String]] = [:]
    private var decades: [String] = []
    private var previousContentOffset: CGPoint = .zero
    private var shouldIgnoreOffsetChangesUntilNextRest = false
    private var currentDecadeTransitionMinY: CGFloat?
    private var currentDecadeTransitionMaxY: CGFloat?

    // MARK: Init methods

    init(decadeStrip: VerticalStrip = VerticalStrip()) {
        self.decadeStrip = decadeStrip
        super.init(frame: .zero)
        backgroundColor = UIColor.whiteColor()

        decadeStrip.userDidChangeValueHandler = { [weak self] index in
            self?.shouldIgnoreOffsetChangesUntilNextRest = true
            let indexPath = NSIndexPath(forItem: 0, inSection: index)
            self?.yearCollectionView.scrollToItemAtIndexPath(indexPath,
                                                             atScrollPosition: .Top,
                                                             animated: true)
        }
        addSubview(decadeStrip)
        decadeStrip.snp_makeConstraints { make in
            make.top.equalTo(1.0)
            make.leading.equalTo(1.0)
            make.bottom.equalTo(-1.0)
            make.width.equalTo(self.snp_width).multipliedBy(0.33)
        }

        let verticalBorder = UIImageView(image: UIImage.imageWithFillColor(UIColor.whiteColor()))
        addSubview(verticalBorder)
        verticalBorder.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(decadeStrip.snp_trailing)
            make.width.equalTo(1.0/UIScreen.mainScreen().scale)
        }

        yearCollectionView.delegate = self
        yearCollectionView.dataSource = self
        yearCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(yearCollectionView)
        yearCollectionView.snp_makeConstraints { make in
            make.top.equalTo(1.0)
            make.bottom.equalTo(-1.0)
            make.leading.equalTo(verticalBorder.snp_trailing).offset(1.0)
            make.trailing.equalTo(-1.0)
        }
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable)
    init() {
        fatalError("init() has not been implemented")
    }

    // MARK: Private methods

    private func updateYearsAndDecades() {
        yearsByDecade = [:]
        decades = []
        if let earliestYear = earliestYear, latestYear = latestYear
            where earliestYear < latestYear {
            let earliestDecade = Int(Float(earliestYear) / 10.0) * 10
            let latestDecade = Int(Float(latestYear) / 10.0) * 10
            var decade = earliestDecade
            while decade <= latestDecade {
                decades.append("\(decade)s")
                let earliestDecadeYear = max(decade, earliestYear)
                let latestDecadeYear = min(decade + 9, latestYear)
                let yearsInDecade = (earliestDecadeYear...latestDecadeYear).map { "\($0)" }
                yearsByDecade["\(decade)s"] = yearsInDecade
                decade += 10
            }
            decadeStrip.items = decades
        }
        yearCollectionView.reloadData()
    }

    private func settle() {
        guard !shouldIgnoreOffsetChangesUntilNextRest else { return }

        guard let visibleHeaderPath = yearCollectionView.lastVisibleHeaderPath else { return }

        let header = yearCollectionView.headerAtIndexPath(visibleHeaderPath)
        let distanceFromTop = header.frame.origin.y - yearCollectionView.contentOffset.y
        let halfwayPoint = yearCollectionView.frame.size.height / 2.0
        var currentSection = visibleHeaderPath.section
        if (distanceFromTop >= halfwayPoint) && (currentSection > 0) {
            currentSection -= 1
        }

        decadeStrip.jumpToItemAtIndex(currentSection)
    }

    private func updateCurrentDecadeTransitionMinY() {

        let topHeaderY = yearCollectionView.minVisibleHeaderY


        let visibleHalfwayY = yearCollectionView.frame.size.height / 2.0
        let typicalDecadeTransitionMinY = visibleHalfwayY -
                                            (ByDecadeYearPicker.decadeTransitionScrollArea / 2.0)
        let typicalDecadeTransitionMaxY = visibleHalfwayY +
                                            (ByDecadeYearPicker.decadeTransitionScrollArea / 2.0)



        // if the year collectionView is resting at a point where transition
        // between decades should happen, then treat this as the decade's "full"
        // position until the drag ends.
        if (topHeaderY >= typicalDecadeTransitionMinY) &&
            (topHeaderY <= typicalDecadeTransitionMaxY) {
            if topHeaderY > visibleHalfwayY {
                currentDecadeTransitionMinY = (topHeaderY ?? 0) -
                                                ByDecadeYearPicker.decadeTransitionScrollArea
            } else {
                currentDecadeTransitionMinY = topHeaderY
            }
        } else {
            currentDecadeTransitionMinY = typicalDecadeTransitionMinY
        }
    }

    // MARK: UICollectionViewDataSource methods

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return decades.count
    }

    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let years = yearsByDecade[decades[section]]
        return years?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ByDecadeYearPickerCell = collectionView.dequeueCellForItemAtIndexPath(indexPath)
        let decade = decades[indexPath.section]
        cell.text = yearsByDecade[decade]?[indexPath.item]
        return cell
    }

    func collectionView(collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueHeaderForIndexPath(indexPath)
        view.backgroundColor = UIColor.whiteColor()
        return view
    }

    static let lineSpacing: CGFloat = 1.0

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        updateCurrentDecadeTransitionMinY()
        let decade = decades[indexPath.section]
        if let year = yearsByDecade[decade]?[indexPath.item] {
            yearTapHandler?(year)
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout methods

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 44)
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ByDecadeYearPicker.lineSpacing
    }

    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 320.0, height: ByDecadeYearPicker.lineSpacing)
    }

    // MARK: UIScrollViewDelegate methods

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.decelerating {
            // Ignore
            return
        }
        updateCurrentDecadeTransitionMinY()
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !scrollView.decelerating {
            shouldIgnoreOffsetChangesUntilNextRest = false
        }
        settle()
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if !scrollView.dragging {
            shouldIgnoreOffsetChangesUntilNextRest = false
        }
        settle()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard !shouldIgnoreOffsetChangesUntilNextRest else { return }

        guard let lowerSectionHeaderPath = yearCollectionView.lastVisibleHeaderPath else {
            return
        }

        // When the header's y origin is here, the lower section should be
        // shown at 100%.
        guard let fullLowerSectionYBoundary = currentDecadeTransitionMinY else { return }
        // When the header's y origin is here, the upper section should be
        // shown at 100%
        let fullUpperSectionYBoundary = fullLowerSectionYBoundary +
                                            ByDecadeYearPicker.decadeTransitionScrollArea

        let lowerSectionHeader = yearCollectionView.headerAtIndexPath(lowerSectionHeaderPath)

        // Position of the header's y origin to the user
        let perceivedLowerSectionY = lowerSectionHeader.frame.origin.y -
                                        yearCollectionView.contentOffset.y

        // The first visible header marks the beginning of the lower section.
        // VerticalStrip wants the upper section, so subtract 1 (unless 0)
        let upperSection = max(lowerSectionHeaderPath.section - 1, 0)

        if (perceivedLowerSectionY >= fullLowerSectionYBoundary) &&
            (perceivedLowerSectionY <= fullUpperSectionYBoundary) {
            // How much would the user need to scroll before upper section should be fully visible?
            let distanceFromFullUpper = fullUpperSectionYBoundary - perceivedLowerSectionY
            let fractionScrolled = distanceFromFullUpper /
                                        ByDecadeYearPicker.decadeTransitionScrollArea
            decadeStrip.showItemAtIndex(upperSection, withFractionScrolled: fractionScrolled)
        } else if perceivedLowerSectionY < fullLowerSectionYBoundary {
            decadeStrip.showItemAtIndex(lowerSectionHeaderPath.section, withFractionScrolled: 0)
        } else if perceivedLowerSectionY > fullUpperSectionYBoundary {
            decadeStrip.showItemAtIndex(upperSection, withFractionScrolled: 0)
        }
    }
}
