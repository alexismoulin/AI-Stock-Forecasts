import Foundation

public struct HMAC {

    internal static func sha1(key: Data, message: Data) -> Data? {
        var key = key.rawBytes
        let message = message.rawBytes

        // key
        if key.count > 64 {
            key = SHA1(Data(bytes: key)).calculate()
        }

        if key.count < 64 {
            key += [UInt8](repeating: 0, count: 64 - key.count)
        }

        //
        var opad = [UInt8](repeating: 0x5c, count: 64)
        for idx in key.indices {
            opad[idx] = key[idx] ^ opad[idx]
        }
        var ipad = [UInt8](repeating: 0x36, count: 64)
        for idx in key.indices {
            ipad[idx] = key[idx] ^ ipad[idx]
        }

        let ipadAndMessageHash = SHA1(Data(bytes: (ipad + message))).calculate()
        let finalHash = SHA1(Data(bytes: opad + ipadAndMessageHash)).calculate()
        let mac = finalHash

        return Data(bytes: mac)

    }

}
