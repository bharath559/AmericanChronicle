enum ChroniclingAmericaEndpoint: String {
    case PagesSearch = "search/pages/results/"

    static let baseURLString = "http://chroniclingamerica.loc.gov/"
    var fullURLString: String? {
        return "\(ChroniclingAmericaEndpoint.baseURLString)\(self.rawValue)"
    }
    var fullURL: URL? { return URL(string: fullURLString ?? "") }
}
