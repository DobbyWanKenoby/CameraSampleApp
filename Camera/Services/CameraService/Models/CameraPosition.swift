enum CameraPosition {
    case front
    case back
    
    var next: CameraPosition {
        switch self {
        case .front:
            .back
        case .back:
            .front
        }
    }
}
