import Foundation

/// A type representing possible errors Moya can throw.
public enum MoyaError: Swift.Error {
    /// Indicates a response failed to map to an image.
    case imageMapping(Response)

    /// Indicates a response failed to map to a JSON structure.
    case jsonMapping(Response)

    /// Indicates a response failed to map to a String.
    case stringMapping(Response)

    /// Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, Response)

    /// Indicates that Encodable couldn't be encoded into Data
    case encodableMapping(Swift.Error)

    /// Indicates a response failed with an invalid HTTP status code.
    case statusCode(Response)

    /// Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error, Response?)

    /// Indicates that an `Endpoint` failed to map to a `URLRequest`.
    case requestMapping(String)

    /// Indicates that an `Endpoint` failed to encode the parameters for the `URLRequest`.
    case parameterEncoding(Swift.Error)
}

public extension MoyaError {
    /// Depending on error type, returns a `Response` object.
    var response: Moya.Response? {
        switch self {
        case let .imageMapping(response): return response
        case let .jsonMapping(response): return response
        case let .stringMapping(response): return response
        case let .objectMapping(_, response): return response
        case let .statusCode(response): return response
        case let .underlying(_, response): return response
        case .encodableMapping: return nil
        case .requestMapping: return nil
        case .parameterEncoding: return nil
        }
    }
}

// MARK: - Error Descriptions

extension MoyaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageMapping:
            return "Failed to map data to an Image."
        case .jsonMapping:
            return "Failed to map data to JSON."
        case .stringMapping:
            return "Failed to map data to a String."
        case .objectMapping:
            return "Failed to map data to a Decodable object."
        case .encodableMapping:
            return "Failed to encode Encodable object into data."
        case .statusCode:
            return "Status code didn't fall within the given range."
        case .requestMapping:
            return "Failed to map Endpoint to a URLRequest."
        case let .parameterEncoding(error):
            return "Failed to encode parameters for URLRequest. \(error.localizedDescription)"
        case .underlying(let error, _):
            return error.localizedDescription
        }
    }
}
