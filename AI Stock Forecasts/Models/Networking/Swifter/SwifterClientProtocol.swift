import Foundation
// swiftlint:disable function_parameter_count
public protocol SwifterAppProtocol {
    var consumerKey: String { get }
    var consumerSecret: String { get }
}

public protocol SwifterClientProtocol {

    var credential: Credential? { get set }

    @discardableResult
    func get(_ path: String,
             baseURL: TwitterURL,
             parameters: [String: Any],
             uploadProgress: HTTPRequest.UploadProgressHandler?,
             downloadProgress: HTTPRequest.DownloadProgressHandler?,
             success: HTTPRequest.SuccessHandler?,
             failure: HTTPRequest.FailureHandler?) -> HTTPRequest

    @discardableResult
    func post(_ path: String,
              baseURL: TwitterURL,
              parameters: [String: Any],
              uploadProgress: HTTPRequest.UploadProgressHandler?,
              downloadProgress: HTTPRequest.DownloadProgressHandler?,
              success: HTTPRequest.SuccessHandler?,
              failure: HTTPRequest.FailureHandler?) -> HTTPRequest

    @discardableResult
    func delete(_ path: String,
                baseURL: TwitterURL,
                parameters: [String: Any],
                success: HTTPRequest.SuccessHandler?,
                failure: HTTPRequest.FailureHandler?) -> HTTPRequest

}
