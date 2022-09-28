import Foundation

#if os(macOS) || os(iOS)
import Accounts
#endif

public class Credential {

    public struct OAuthAccessToken {

        public internal(set) var key: String
        public internal(set) var secret: String
        public internal(set) var verifier: String?
        public internal(set) var screenName: String?
        public internal(set) var userID: String?

        public init(key: String, secret: String) {
            self.key = key
            self.secret = secret
            self.userID = key.components(separatedBy: "-").first
        }

        public init(queryString: String) {
            let attributes = queryString.queryStringParameters
            self.key = attributes["oauth_token"]!
            self.secret = attributes["oauth_token_secret"]!
            self.screenName = attributes["screen_name"]
            self.userID = attributes["user_id"]
        }

    }

    public internal(set) var accessToken: OAuthAccessToken?

    #if os(macOS) || os(iOS)
    @available(iOS, deprecated: 11.0, message: "Using ACAccount for Twitter is no longer supported as of iOS 11.")
    public internal(set) var account: ACAccount?

    @available(iOS, deprecated: 11.0, message: "Using ACAccount for Twitter is no longer supported as of iOS 11.")
    public init(account: ACAccount) {
        self.account = account
    }
    #endif

    public init(accessToken: OAuthAccessToken) {
        self.accessToken = accessToken
    }

}
