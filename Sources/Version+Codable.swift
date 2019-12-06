extension Version: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let s = try container.decode(String.self)
        let initializer: (String) -> Version?
        if decoder.userInfo[.decodingMethod] as? DecodingMethod == .tolerant {
            initializer = Version.init(tolerant:)
        } else {
            initializer = Version.init
        }
        guard let v = initializer(s) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid semantic version")
        }
        self = v
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

/// The method to be used when decoding a Version
public enum DecodingMethod {
    /// Decode using the strict initializer
    case strict
    /// Decode using the tolerant initializer
    case tolerant
}

public extension CodingUserInfoKey {
    /// A value indicating what decoding method to use: tolerant or strict. Default value is strict
    static let decodingMethod = CodingUserInfoKey(rawValue: "dev.mxcl.Version.decodingMethod")!
}
