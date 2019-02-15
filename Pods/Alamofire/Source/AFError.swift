//
//  AFError.swift
//
//  Copyright (c) 2014 Alamofire Software Foundation (http://alamofire.org/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// `AFError` is the error type returned by Alamofire. It encompasses a few different types of errors, each with
/// their own associated reasons.
///
/// - invalidURL:                  Returned when a `URLConvertible` type fails to create a valid `URL`.
/// - parameterEncodingFailed:     Returned when a parameter encoding object throws an error during the encoding process.
/// - multipartEncodingFailed:     Returned when some step in the multipart encoding process fails.
/// - responseValidationFailed:    Returned when a `validate()` call fails.
/// - responseSerializationFailed: Returned when a response serializer encounters an error in the serialization process.
public enum AFError: Error {
    /// The underlying reason the parameter encoding error occurred.
    ///
    /// - missingURL:                 The URL request did not have a URL to encode.
    /// - jsonEncodingFailed:         JSON serialization failed with an underlying system error during the
    ///                               encoding process.
    /// - propertyListEncodingFailed: Property list serialization failed with an underlying system error during
    ///                               encoding process.
    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }

    /// The underlying reason the multipart encoding error occurred.
    ///
    /// - bodyPartURLInvalid:                   The `fileURL` provided for reading an encodable body part isn't a
    ///                                         file URL.
    /// - bodyPartFilenameInvalid:              The filename of the `fileURL` provided has either an empty
    ///                                         `lastPathComponent` or `pathExtension.
    /// - bodyPartFileNotReachable:             The file at the `fileURL` provided was not reachable.
    /// - bodyPartFileNotReachableWithError:    Attempting to check the reachability of the `fileURL` provided threw
    ///                                         an error.
    /// - bodyPartFileIsDirectory:              The file at the `fileURL` provided is actually a directory.
    /// - bodyPartFileSizeNotAvailable:         The size of the file at the `fileURL` provided was not returned by
    ///                                         the system.
    /// - bodyPartFileSizeQueryFailedWithError: The attempt to find the size of the file at the `fileURL` provided
    ///                                         threw an error.
    /// - bodyPartInputStreamCreationFailed:    An `InputStream` could not be created for the provided `fileURL`.
    /// - outputStreamCreationFailed:           An `OutputStream` could not be created when attempting to write the
    ///                                         encoded data to disk.
    /// - outputStreamFileAlreadyExists:        The encoded body data could not be writtent disk because a file
    ///                                         already exists at the provided `fileURL`.
    /// - outputStreamURLInvalid:               The `fileURL` provided for writing the encoded body data to disk is
    ///                                         not a file URL.
    /// - outputStreamWriteFailed:              The attempt to write the encoded body data to disk failed with an
    ///                                         underlying error.
    /// - inputStreamReadFailed:                The attempt to read an encoded body part `InputStream` failed with
    ///                                         underlying system error.
    public enum MultipartEncodingFailureReason {
        case bodyPartURLInvalid(url: URL)
        case bodyPartFilenameInvalid(in: URL)
        case bodyPartFileNotReachable(at: URL)
        case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
        case bodyPartFileIsDirectory(at: URL)
        case bodyPartFileSizeNotAvailable(at: URL)
        case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
        case bodyPartInputStreamCreationFailed(for: URL)

        case outputStreamCreationFailed(for: URL)
        case outputStreamFileAlreadyExists(at: URL)
        case outputStreamURLInvalid(url: URL)
        case outputStreamWriteFailed(error: Error)

        case inputStreamReadFailed(error: Error)
    }

    /// The underlying reason the response validation error occurred.
    ///
    /// - dataFileNil:             The data file containing the server response did not exist.
    /// - dataFileReadFailed:      The data file containing the server response could not be read.
    /// - missingContentType:      The response did not contain a `Content-Type` and the `acceptableContentTypes`
    ///                            provided did not contain wildcard type.
    /// - unacceptableContentType: The response `Content-Type` did not match any type in the provided
    ///                            `acceptableContentTypes`.
    /// - unacceptableStatusCode:  The response status code was not acceptable.
    public enum ResponseValidationFailureReason {
        case dataFileNil
        case dataFileReadFailed(at: URL)
        case missingContentType(acceptableContentTypes: [String])
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int)
    }

    /// The underlying reason the response serialization error occurred.
    ///
    /// - inputDataNil:                    The server response contained no data.
    /// - inputDataNilOrZeroLength:        The server response contained no data or the data was zero length.
    /// - inputFileNil:                    The file containing the server response did not exist.
    /// - inputFileReadFailed:             The file containing the server response could not be read.
    /// - stringSerializationFailed:       String serialization failed using the provided `String.Encoding`.
    /// - jsonSerializationFailed:         JSON serialization failed with an underlying system error.
    /// - propertyListSerializationFailed: Property list serialization failed with an underlying system error.
    public enum ResponseSerializationFailureReason {
        case inputDataNil
        case inputDataNilOrZeroLength
        case inputFileNil
        case inputFileReadFailed(at: URL)
        case stringSerializationFailed(encoding: String.Encoding)
        case jsonSerializationFailed(error: Error)
        case propertyListSerializationFailed(error: Error)
    }

    case invalidURL(url: URLConvertible)
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
    case responseValidationFailed(reason: ResponseValidationFailureReason)
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)
}

// MARK: - Adapt Error

struct AdaptError: Error {
    let error: Error
}

extension Error {
    var underlyingAdaptError: Error? { return (self as? AdaptError)?.error }
}

// MARK: - Error Booleans

extension AFError {
    /// Returns whether the AFError is an invalid URL error.
    public var isInvalidURLError: Bool {
        if case .invalidURL = self { return true }
        return false
    }

    /// Returns whether the AFError is a parameter encoding error. When `true`, the `underlyingError` property will
    /// contain the associated value.
    public var isParameterEncodingError: Bool {
        if case .parameterEncodingFailed = self { return true }
        return false
    }

    /// Returns whether the AFError is a multipart encoding error. When `true`, the `url` and `underlyingError` properties
    /// will contain the associated values.
    public var isMultipartEncodingError: Bool {
        if case .multipartEncodingFailed = self { return true }
        return false
    }

    /// Returns whether the `AFError` is a response validation error. When `true`, the `acceptableContentTypes`,
    /// `responseContentType`, and `responseCode` properties will contain the associated values.
    public var isResponseValidationError: Bool {
        if case .responseValidationFailed = self { return true }
        return false
    }

    /// Returns whether the `AFError` is a response serialization error. When `true`, the `failedStringEncoding` and
    /// `underlyingError` properties will contain the associated values.
    public var isResponseSerializationError: Bool {
        if case .responseSerializationFailed = self { return true }
        return false
    }
}

// MARK: - Convenience Properties

extension AFError {
    /// The `URLConvertible` associated with the error.
    public var urlConvertible: URLConvertible? {
        switch self {
        case let .invalidURL(url):
            return url
        default:
            return nil
        }
    }

    /// The `URL` associated with the error.
    public var url: URL? {
        switch self {
        case let .multipartEncodingFailed(reason):
            return reason.url
        default:
            return nil
        }
    }

    /// The `Error` returned by a system framework associated with a `.parameterEncodingFailed`,
    /// `.multipartEncodingFailed` or `.responseSerializationFailed` error.
    public var underlyingError: Error? {
        switch self {
        case let .parameterEncodingFailed(reason):
            return reason.underlyingError
        case let .multipartEncodingFailed(reason):
            return reason.underlyingError
        case let .responseSerializationFailed(reason):
            return reason.underlyingError
        default:
            return nil
        }
    }

    /// The acceptable `Content-Type`s of a `.responseValidationFailed` error.
    public var acceptableContentTypes: [String]? {
        switch self {
        case let .responseValidationFailed(reason):
            return reason.acceptableContentTypes
        default:
            return nil
        }
    }

    /// The response `Content-Type` of a `.responseValidationFailed` error.
    public var responseContentType: String? {
        switch self {
        case let .responseValidationFailed(reason):
            return reason.responseContentType
        default:
            return nil
        }
    }

    /// The response code of a `.responseValidationFailed` error.
    public var responseCode: Int? {
        switch self {
        case let .responseValidationFailed(reason):
            return reason.responseCode
        default:
            return nil
        }
    }

    /// The `String.Encoding` associated with a failed `.stringResponse()` call.
    public var failedStringEncoding: String.Encoding? {
        switch self {
        case let .responseSerializationFailed(reason):
            return reason.failedStringEncoding
        default:
            return nil
        }
    }
}

extension AFError.ParameterEncodingFailureReason {
    var underlyingError: Error? {
        switch self {
        case let .jsonEncodingFailed(error), let .propertyListEncodingFailed(error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var url: URL? {
        switch self {
        case let .bodyPartURLInvalid(url), let .bodyPartFilenameInvalid(url), let .bodyPartFileNotReachable(url),
             let .bodyPartFileIsDirectory(url), let .bodyPartFileSizeNotAvailable(url),
             let .bodyPartInputStreamCreationFailed(url), let .outputStreamCreationFailed(url),
             let .outputStreamFileAlreadyExists(url), let .outputStreamURLInvalid(url),
             .bodyPartFileNotReachableWithError(let url, _), .bodyPartFileSizeQueryFailedWithError(let url, _):
            return url
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case let .bodyPartFileNotReachableWithError(_, error), let .bodyPartFileSizeQueryFailedWithError(_, error),
             let .outputStreamWriteFailed(error), let .inputStreamReadFailed(error):
            return error
        default:
            return nil
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var acceptableContentTypes: [String]? {
        switch self {
        case let .missingContentType(types), .unacceptableContentType(let types, _):
            return types
        default:
            return nil
        }
    }

    var responseContentType: String? {
        switch self {
        case let .unacceptableContentType(_, responseType):
            return responseType
        default:
            return nil
        }
    }

    var responseCode: Int? {
        switch self {
        case let .unacceptableStatusCode(code):
            return code
        default:
            return nil
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var failedStringEncoding: String.Encoding? {
        switch self {
        case let .stringSerializationFailed(encoding):
            return encoding
        default:
            return nil
        }
    }

    var underlyingError: Error? {
        switch self {
        case let .jsonSerializationFailed(error), let .propertyListSerializationFailed(error):
            return error
        default:
            return nil
        }
    }
}

// MARK: - Error Descriptions

extension AFError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            return "URL is not valid: \(url)"
        case let .parameterEncodingFailed(reason):
            return reason.localizedDescription
        case let .multipartEncodingFailed(reason):
            return reason.localizedDescription
        case let .responseValidationFailed(reason):
            return reason.localizedDescription
        case let .responseSerializationFailed(reason):
            return reason.localizedDescription
        }
    }
}

extension AFError.ParameterEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case .missingURL:
            return "URL request to encode was missing a URL"
        case let .jsonEncodingFailed(error):
            return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
        case let .propertyListEncodingFailed(error):
            return "PropertyList could not be encoded because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.MultipartEncodingFailureReason {
    var localizedDescription: String {
        switch self {
        case let .bodyPartURLInvalid(url):
            return "The URL provided is not a file URL: \(url)"
        case let .bodyPartFilenameInvalid(url):
            return "The URL provided does not have a valid filename: \(url)"
        case let .bodyPartFileNotReachable(url):
            return "The URL provided is not reachable: \(url)"
        case let .bodyPartFileNotReachableWithError(url, error):
            return (
                "The system returned an error while checking the provided URL for " +
                    "reachability.\nURL: \(url)\nError: \(error)"
            )
        case let .bodyPartFileIsDirectory(url):
            return "The URL provided is a directory: \(url)"
        case let .bodyPartFileSizeNotAvailable(url):
            return "Could not fetch the file size from the provided URL: \(url)"
        case let .bodyPartFileSizeQueryFailedWithError(url, error):
            return (
                "The system returned an error while attempting to fetch the file size from the " +
                    "provided URL.\nURL: \(url)\nError: \(error)"
            )
        case let .bodyPartInputStreamCreationFailed(url):
            return "Failed to create an InputStream for the provided URL: \(url)"
        case let .outputStreamCreationFailed(url):
            return "Failed to create an OutputStream for URL: \(url)"
        case let .outputStreamFileAlreadyExists(url):
            return "A file already exists at the provided URL: \(url)"
        case let .outputStreamURLInvalid(url):
            return "The provided OutputStream URL is invalid: \(url)"
        case let .outputStreamWriteFailed(error):
            return "OutputStream write failed with error: \(error)"
        case let .inputStreamReadFailed(error):
            return "InputStream read failed with error: \(error)"
        }
    }
}

extension AFError.ResponseSerializationFailureReason {
    var localizedDescription: String {
        switch self {
        case .inputDataNil:
            return "Response could not be serialized, input data was nil."
        case .inputDataNilOrZeroLength:
            return "Response could not be serialized, input data was nil or zero length."
        case .inputFileNil:
            return "Response could not be serialized, input file was nil."
        case let .inputFileReadFailed(url):
            return "Response could not be serialized, input file could not be read: \(url)."
        case let .stringSerializationFailed(encoding):
            return "String could not be serialized with encoding: \(encoding)."
        case let .jsonSerializationFailed(error):
            return "JSON could not be serialized because of error:\n\(error.localizedDescription)"
        case let .propertyListSerializationFailed(error):
            return "PropertyList could not be serialized because of error:\n\(error.localizedDescription)"
        }
    }
}

extension AFError.ResponseValidationFailureReason {
    var localizedDescription: String {
        switch self {
        case .dataFileNil:
            return "Response could not be validated, data file was nil."
        case let .dataFileReadFailed(url):
            return "Response could not be validated, data file could not be read: \(url)."
        case let .missingContentType(types):
            return (
                "Response Content-Type was missing and acceptable content types " +
                    "(\(types.joined(separator: ","))) do not match \"*/*\"."
            )
        case let .unacceptableContentType(acceptableTypes, responseType):
            return (
                "Response Content-Type \"\(responseType)\" does not match any acceptable types: " +
                    "\(acceptableTypes.joined(separator: ","))."
            )
        case let .unacceptableStatusCode(code):
            return "Response status code was unacceptable: \(code)."
        }
    }
}
