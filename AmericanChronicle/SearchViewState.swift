// http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack
enum SearchViewState: Equatable, CustomStringConvertible {
    case EmptySearchField // Blank (A)
    case EmptyResults // Blank (B)
    case LoadingNewParamaters
    case LoadingMoreRows
    case Partial(title: String, rows: [SearchResultsRow])
    case Ideal(title: String, rows: [SearchResultsRow])
    case Error(title: String?, message: String?)

    var description: String {
        var desc = "<ViewState: "
        switch self {
        case .EmptySearchField: desc += "EmptySearchField"
        case .EmptyResults: desc += "EmptyResults"
        case .LoadingNewParamaters: desc += "LoadingNewParamaters"
        case .LoadingMoreRows: desc += "LoadingMoreRows"
        case let .Partial(title, rows):
            desc += "Partial, title=\(title), rows=["
            desc += rows.map({"\($0.description)" }).joinWithSeparator(", ")
            desc += "]"
        case let .Ideal(title, rows):
            desc += "Ideal, title=\(title), rows=["
            desc += rows.map({"\($0.description)" }).joinWithSeparator(", ")
            desc += "]"
        case let .Error(title, message):
            desc += "Error, title=\(title), message=\(message)"
        }
        desc += ">"
        return desc
    }
}

func == (viewA: SearchViewState, viewB: SearchViewState) -> Bool {
    switch (viewA, viewB) {
    case (.EmptySearchField, .EmptySearchField): return true
    case (.EmptyResults, .EmptyResults): return true
    case (.LoadingNewParamaters, .LoadingNewParamaters): return true
    case (.LoadingMoreRows, .LoadingMoreRows): return true
    case (let .Partial(titleA, rowsA), let .Partial(titleB, rowsB)):
        return (titleA == titleB) && (rowsA == rowsB)
    case (let .Ideal(titleA, rowsA), let .Ideal(titleB, rowsB)):
        return (titleA == titleB) && (rowsA == rowsB)
    case (let .Error(titleA, messageA), let .Error(titleB, messageB)):
        return (titleA == titleB) && (messageA == messageB)
    default: return false
    }
}
