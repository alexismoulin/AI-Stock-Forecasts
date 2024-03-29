import Foundation
// swiftlint:disable identifier_name
// swiftlint:disable function_body_length
struct SHA1 {

    private var message: [UInt8]
    fileprivate let h: [UInt32] = [0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0]

    init(_ message: Data) {
        self.message = message.rawBytes
    }
    init(_ message: [UInt8]) {
        self.message = message
    }

    /// Common part for hash calculation. Prepare header data.
    func prepare(_ message: [UInt8], _ blockSize: Int, _ allowance: Int) -> [UInt8] {
        var tmpMessage = message
        // Step 1. Append Padding Bits
        tmpMessage.append(0x80) // append one bit (Byte with one bit) to message
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        var msgLength = tmpMessage.count
        var counter = 0

        while msgLength % blockSize != (blockSize - allowance) {
            counter += 1
            msgLength += 1
        }

        tmpMessage += [UInt8](repeating: 0, count: counter)
        return tmpMessage
    }

    func calculate() -> [UInt8] {
        var tmpMessage = self.prepare(self.message, 64, 64 / 8)
        // hash values
        var hh = h
        // append message length, in a 64-bit big-endian integer. So now the message length is a multiple of 512 bits.
        tmpMessage += (self.message.count * 8).bytes(64 / 8)
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        for chunk in BytesSequence(data: tmpMessage, chunkSize: chunkSizeBytes) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
            // Extend the sixteen 32-bit words into eighty 32-bit words:
            var M: [UInt32] = [UInt32](repeating: 0, count: 80)
            for x in 0..<M.count {
                switch x {
                case 0...15:
                    let memorySize = MemoryLayout<UInt32>.size
                    let start = chunk.startIndex + (x * memorySize)
                    let end = start + memorySize
                    let le = chunk[start..<end].toUInt32
                    M[x] = le.bigEndian
                default:
                    M[x] = rotateLeft(M[x-3] ^ M[x-8] ^ M[x-14] ^ M[x-16], n: 1)
                }
            }

            var A = hh[0], B = hh[1], C = hh[2], D = hh[3], E = hh[4]

            // Main loop
            for j in 0...79 {
                var f: UInt32 = 0
                var k: UInt32 = 0

                switch j {
                case 0...19:
                    f = (B & C) | ((~B) & D)
                    k = 0x5A827999
                case 20...39:
                    f = B ^ C ^ D
                    k = 0x6ED9EBA1
                case 40...59:
                    f = (B & C) | (B & D) | (C & D)
                    k = 0x8F1BBCDC
                case 60...79:
                    f = B ^ C ^ D
                    k = 0xCA62C1D6
                default:
                    break
                }

                let temp = (rotateLeft(A, n: 5) &+ f &+ E &+ M[j] &+ k) & 0xffffffff
                E = D
                D = C
                C = rotateLeft(B, n: 30)
                B = A
                A = temp

            }

            hh[0] = (hh[0] &+ A) & 0xffffffff
            hh[1] = (hh[1] &+ B) & 0xffffffff
            hh[2] = (hh[2] &+ C) & 0xffffffff
            hh[3] = (hh[3] &+ D) & 0xffffffff
            hh[4] = (hh[4] &+ E) & 0xffffffff
        }
        // Produce the final hash value (big-endian) as a 160 bit number:
        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)
        hh.forEach {
            let item = $0.bigEndian
            result += [
                UInt8(item & 0xff),
                UInt8((item >> 8) & 0xff),
                UInt8((item >> 16) & 0xff),
                UInt8((item >> 24) & 0xff)
            ]
        }
        return result
    }

    private func rotateLeft(_ v: UInt32, n: UInt32) -> UInt32 {
        return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
    }

}

private struct BytesSequence<D: RandomAccessCollection>: Sequence where D.Iterator.Element == UInt8, D.Index == Int {
    let data: D
    let chunkSize: Int

    func makeIterator() -> AnyIterator<D.SubSequence> {
        var offset = data.startIndex
        return AnyIterator {
            let end = Swift.min(self.chunkSize, self.data.count - offset)
            let result = self.data[offset..<offset + end]
            offset = offset.advanced(by: result.count)
            if !result.isEmpty {
                return result
            }
            return nil
        }
    }

}

extension Collection where Self.Iterator.Element == UInt8, Self.Index == Int {

    var toUInt32: UInt32 {
        assert(self.count > 3)
        // XXX optimize do the job only for the first one...
        return toUInt32Array()[0]
    }

    func toUInt32Array() -> [UInt32] {
        var result = [UInt32]()
        result.reserveCapacity(16)
        for idx in stride(from: self.startIndex, to: self.endIndex, by: MemoryLayout<UInt32>.size) {
            var val: UInt32 = 0
            val |= self.count > 3 ? UInt32(self[idx.advanced(by: 3)]) << 24 : 0
            val |= self.count > 2 ? UInt32(self[idx.advanced(by: 2)]) << 16 : 0
            val |= self.count > 1 ? UInt32(self[idx.advanced(by: 1)]) << 8  : 0
            // swiftlint:disable:next empty_count
            val |= self.count > 0 ? UInt32(self[idx]) : 0
            result.append(val)
        }

        return result
    }
}
