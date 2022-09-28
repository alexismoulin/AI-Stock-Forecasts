import Foundation

extension Data {

    var rawBytes: [UInt8] {
        return [UInt8](self)
    }

    init(bytes: [UInt8]) {
        self.init(bytes)
    }

}
