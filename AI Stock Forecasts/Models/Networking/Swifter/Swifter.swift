import Foundation
import Dispatch
import AuthenticationServices

#if os(macOS) || os(iOS)
import Accounts
#endif

extension Notification.Name {
    static let swifterCallback = Notification.Name(rawValue: "Swifter.CallbackNotificationName")
    static let swifterSSOCallback = Notification.Name(rawValue: "Swifter.SSOCallbackNotificationName")
}

// MARK: - Twitter URL
public enum TwitterURL {

    case api
    case oauth

    var url: URL {
        switch self {
        case .api:
            return URL(string: "https://api.twitter.com/1.1/")!
        case .oauth:
            return URL(string: "https://api.twitter.com/")!
        }
    }

}

// MARK: - Tweet Mode
public enum TweetMode {

    case `default`
    case extended
    case compat
    case other(String)

    var stringValue: String? {
        switch self {
        case .default:
            return nil
        case .extended:
            return "extended"
        case .compat:
            return "compat"
        case .other(let string):
            return string
        }
    }
}

public class Swifter {

    static var basic = Swifter(consumerKey: Keys.twitterKey, consumerSecret: Keys.twitterSecretKey)

    // MARK: - Types

    public typealias SuccessHandler = (JSON) -> Void
    public typealias CursorSuccessHandler = (JSON, _ previousCursor: String?, _ nextCursor: String?) -> Void
    public typealias JSONSuccessHandler = (JSON, _ response: HTTPURLResponse) -> Void
    public typealias SearchResultHandler = (JSON, _ searchMetadata: JSON) -> Void
    public typealias FailureHandler = (_ error: Error) -> Void

    internal struct CallbackNotification {
        static let optionsURLKey = "SwifterCallbackNotificationOptionsURLKey"
    }

    internal struct DataParameters {
        static let dataKey = "SwifterDataParameterKey"
        static let fileNameKey = "SwifterDataParameterFilename"
        static let jsonDataKey = "SwifterDataJSONDataParameterKey"
    }

    // MARK: - Properties

    public var client: SwifterClientProtocol
    private var chunkBuffer: String?

    internal var swifterCallbackToken: NSObjectProtocol? {
        willSet {
            guard let token = swifterCallbackToken else { return }
            NotificationCenter.default.removeObserver(token)
        }
    }

    private var storedSession: Any?
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    internal var session: ASWebAuthenticationSession? {
        get { return storedSession as? ASWebAuthenticationSession }
        set { storedSession = newValue as Any }
    }

    // MARK: - Initializers

    public init(consumerKey: String, consumerSecret: String, appOnly: Bool = false) {
        self.client = appOnly
            ? AppOnlyClient(consumerKey: consumerKey, consumerSecret: consumerSecret)
            : OAuthClient(consumerKey: consumerKey, consumerSecret: consumerSecret)
    }

    public init(consumerKey: String, consumerSecret: String, oauthToken: String, oauthTokenSecret: String) {
        self.client = OAuthClient(consumerKey: consumerKey, consumerSecret: consumerSecret,
                                  accessToken: oauthToken, accessTokenSecret: oauthTokenSecret)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - JSON Requests

    @discardableResult
    internal func jsonRequest(path: String,
                              baseURL: TwitterURL,
                              method: HTTPMethodType,
                              parameters: [String: Any],
                              uploadProgress: HTTPRequest.UploadProgressHandler? = nil,
                              downloadProgress: JSONSuccessHandler? = nil,
                              success: JSONSuccessHandler? = nil,
                              failure: HTTPRequest.FailureHandler? = nil) -> HTTPRequest {

        let jsonDownloadProgressHandler: HTTPRequest.DownloadProgressHandler = { [weak self] data, _, _, response in
            if let progress = downloadProgress {
                self?.handleStreamProgress(data: data, response: response, handler: progress)
            }
        }

        let jsonSuccessHandler: HTTPRequest.SuccessHandler = { data, response in
            DispatchQueue.global(qos: .utility).async {
                do {
                    let jsonResult = try JSON.parse(jsonData: data)
                    DispatchQueue.main.async {
                        success?(jsonResult, response)
                    }
                } catch {
                    DispatchQueue.main.async {
                        if case 200...299 = response.statusCode, data.isEmpty {
                            success?(JSON("{}"), response)
                        } else {
                            failure?(error)
                        }
                    }
                }
            }
        }

        switch method {
        case .GET:
            return self.client.get(path, baseURL: baseURL, parameters: parameters,
                                   uploadProgress: uploadProgress, downloadProgress: jsonDownloadProgressHandler,
                                   success: jsonSuccessHandler, failure: failure)
        case .POST:
            return self.client.post(path, baseURL: baseURL, parameters: parameters,
                                    uploadProgress: uploadProgress, downloadProgress: jsonDownloadProgressHandler,
                                    success: jsonSuccessHandler, failure: failure)
        case .DELETE:
            return self.client.delete(path, baseURL: baseURL, parameters: parameters,
                                      success: jsonSuccessHandler, failure: failure)
        default:
            fatalError("This HTTP Method is not supported")
        }
    }

    private func handleStreamProgress(data: Data, response: HTTPURLResponse, handler: JSONSuccessHandler? = nil) {
        let chunkSeparator = "\r\n"
        if var jsonString = String(data: data, encoding: .utf8) {
            if let remaining = chunkBuffer {
                jsonString = remaining + jsonString
            }
            let jsonChunks = jsonString.components(separatedBy: chunkSeparator)
            for chunk in jsonChunks where !chunk.utf16.isEmpty {
                if let chunkData = chunk.data(using: .utf8) {
                    guard let jsonResult = try? JSON.parse(jsonData: chunkData) else {
                        self.chunkBuffer = chunk
                        return
                    }
                    chunkBuffer = nil
                    handler?(jsonResult, response)
                }
            }
        }
    }

    @discardableResult
    internal func getJSON(path: String,
                          baseURL: TwitterURL,
                          parameters: [String: Any],
                          uploadProgress: HTTPRequest.UploadProgressHandler? = nil,
                          downloadProgress: JSONSuccessHandler? = nil,
                          success: JSONSuccessHandler?,
                          failure: HTTPRequest.FailureHandler?) -> HTTPRequest {
        return self.jsonRequest(path: path, baseURL: baseURL, method: .GET, parameters: parameters,
                                uploadProgress: uploadProgress, downloadProgress: downloadProgress,
                                success: success, failure: failure)
    }

    @discardableResult
    internal func postJSON(path: String,
                           baseURL: TwitterURL,
                           parameters: [String: Any],
                           uploadProgress: HTTPRequest.UploadProgressHandler? = nil,
                           downloadProgress: JSONSuccessHandler? = nil,
                           success: JSONSuccessHandler?,
                           failure: HTTPRequest.FailureHandler?) -> HTTPRequest {
        return self.jsonRequest(path: path, baseURL: baseURL, method: .POST, parameters: parameters,
                                uploadProgress: uploadProgress, downloadProgress: downloadProgress,
                                success: success, failure: failure)
    }

    @discardableResult
    internal func deleteJSON(path: String,
                             baseURL: TwitterURL,
                             parameters: [String: Any],
                             success: JSONSuccessHandler?,
                             failure: HTTPRequest.FailureHandler?) -> HTTPRequest {
        return self.jsonRequest(path: path, baseURL: baseURL, method: .DELETE, parameters: parameters,
                                success: success, failure: failure)
    }

}
