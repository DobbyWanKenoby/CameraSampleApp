enum LoggerMessageType: String {
    case routing
    case ui
    case network
    case bussinesLogic
}

enum LoggerMessageLevel: Int {
    
    case debug
    case info
    case warning
    
    var title: String {
        switch self {
        case .debug: "ℹ️ DEBUG"
        case .info: "ℹ️ INFO"
        case .warning: "⚠️ WARNING"
        }
    }

}



func info(
    _ type: LoggerMessageType,
    message: String,
    function: String = #function,
    file: String = #file,
    line: Int = #line,
    column: Int = #column
) {
    print(.info, type, message: message, function: function, file: file, line: line, column: column)
}

func warning(
    _ type: LoggerMessageType,
    message: String,
    function: String = #function,
    file: String = #file,
    line: Int = #line,
    column: Int = #column
) {
    print(.warning, type, message: message, function: function, file: file, line: line, column: column)
}

func debug(
    _ type: LoggerMessageType,
    message: String,
    function: String = #function,
    file: String = #file,
    line: Int = #line,
    column: Int = #column
) {
    print(.debug, type, message: message, function: function, file: file, line: line, column: column)
}

private func print(
    _ level: LoggerMessageLevel,
    _ type: LoggerMessageType,
    message: String,
    function: String = #function,
    file: String = #file,
    line: Int = #line,
    column: Int = #column
) {
    guard GlobalGonfiguration.showLoggerLevels.contains(level) else { return }
    let resultMessage = """
    \(level.title)
    TYPE: \(type.rawValue)
    FUNCTION: \(function)
    FILE: \(file), LINE: \(line), COLUMN \(column)
    MESSAGE: \(message)
    """
    print(resultMessage)
}
