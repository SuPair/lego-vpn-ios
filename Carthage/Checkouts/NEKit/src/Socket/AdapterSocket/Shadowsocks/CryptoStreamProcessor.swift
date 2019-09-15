import Foundation

extension ShadowsocksAdapter {
    public static let kChangeLocalPublicKey = "kChangeLocalPublicKey"
    public class CryptoStreamProcessor {
        public class Factory {
            let password: String
            let algorithm: CryptoAlgorithm
            let key: Data

            public init(password: String, algorithm: CryptoAlgorithm) {
                self.password = password
                self.algorithm = algorithm
                key = CryptoHelper.getKey(password, methodType: algorithm)
            }

            public func build(in_pubkey: String, in_method: String) -> CryptoStreamProcessor {
                let array : Array = in_method.components(separatedBy: ",")
                var vpn_ip = UInt32(array[1]) as! UInt32
                var vpn_port = UInt16(array[2]) as! UInt16
                return CryptoStreamProcessor(
                    key: key,
                    algorithm: algorithm,
                    pubkey: in_pubkey,
                    method: array[0],
                    choose_vpn_ip: vpn_ip,
                    choose_vpn_port: vpn_port)
            }
        }

        public weak var inputStreamProcessor: StreamObfuscater.StreamObfuscaterBase!
        public weak var outputStreamProcessor: ProtocolObfuscater.ProtocolObfuscaterBase!

        var readIV: Data!
        let key: Data
        let algorithm: CryptoAlgorithm

        var sendKey = false
        var local_public_key = "555555555555555555555555555555555"
        var method = "aes-256-cfb"
        var choose_vpn_node_int_ip: UInt32 = 0
        var choose_vpn_node_port: UInt16 = 0

        var buffer = Buffer(capacity: 0)

        lazy var writeIV: Data = {
            [unowned self] in
            CryptoHelper.getIV(self.algorithm)
            }()
        lazy var ivLength: Int = {
            [unowned self] in
            CryptoHelper.getIVLength(self.algorithm)
            }()
        lazy var encryptor: StreamCryptoProtocol = {
            [unowned self] in
            self.getCrypto(.encrypt)
            }()
        lazy var decryptor: StreamCryptoProtocol = {
            [unowned self] in
            self.getCrypto(.decrypt)
            }()

        init(
                key: Data,
                algorithm: CryptoAlgorithm,
                pubkey: String,
                method: String,
                choose_vpn_ip: UInt32,
                choose_vpn_port: UInt16) {
            self.key = key
            self.algorithm = algorithm
            self.local_public_key = pubkey
            self.method = method
            self.choose_vpn_node_int_ip = choose_vpn_ip
            self.choose_vpn_node_port = choose_vpn_port
        }

        func changeLocalPublicKey(local_pubkey: String) {
            assert(false, "fuck you!")
            local_public_key = local_pubkey;
        }
        
        func encrypt(data: inout Data) {
            return encryptor.update(&data)
        }

        func decrypt(data: inout Data) {
            return decryptor.update(&data)
        }

        public func input(data: Data) throws {
            var data = data

            if readIV == nil {
                buffer.append(data: data)
                readIV = buffer.get(length: ivLength)
                guard readIV != nil else {
                    try inputStreamProcessor!.input(data: Data())
                    return
                }

                data = buffer.get() ?? Data()
                buffer.release()
            }

            decrypt(data: &data)
            try inputStreamProcessor!.input(data: data)
        }

        private func relayData(withData data: Data) -> Data {
            let method = self.method
            let start_pos = 7
            let public_len = 66
            let length = start_pos + public_len + 1 + method.utf8.count + data.count
            var response = Data(count: length)
            
            response[0] = 1
            var beip = UInt32(self.choose_vpn_node_int_ip)
            withUnsafeBytes(of: &beip) {
                response.replaceSubrange(1..<5, with: $0)
            }
            
            var beport = UInt16(self.choose_vpn_node_port).bigEndian
            withUnsafeBytes(of: &beport) {
                response.replaceSubrange(5..<7, with: $0)
            }
            
            response.replaceSubrange(start_pos..<(start_pos + public_len), with: self.local_public_key.utf8)
            response[start_pos + public_len] = UInt8(method.utf8.count)
            response.replaceSubrange(
                (start_pos + public_len + 1)..<(start_pos + public_len + 1 + method.utf8.count),
                with: method.utf8)
            response.replaceSubrange((start_pos + public_len + 1 + method.utf8.count)..<length, with: data)
            return response
        }

        
        public func output(data: Data) {
            var data = data
            encrypt(data: &data)
            //assert(false, "fuck it")
            if sendKey {
                return outputStreamProcessor!.output(data: data)
            } else {
                sendKey = true
                var out = Data(capacity: data.count + writeIV.count)
                out.append(writeIV)
                out.append(data)

                print("hello world")
                return outputStreamProcessor!.output(data: relayData(withData: out))
            }
        }

        private func getCrypto(_ operation: CryptoOperation) -> StreamCryptoProtocol {
            switch algorithm {
            case .AES128CFB, .AES192CFB, .AES256CFB:
                switch operation {
                case .decrypt:
                    return CCCrypto(operation: .decrypt, mode: .cfb, algorithm: .aes, initialVector: readIV, key: key)
                case .encrypt:
                    return CCCrypto(operation: .encrypt, mode: .cfb, algorithm: .aes, initialVector: writeIV, key: key)
                }
            case .CHACHA20:
                switch operation {
                case .decrypt:
                    return SodiumStreamCrypto(key: key, iv: readIV, algorithm: .chacha20)
                case .encrypt:
                    return SodiumStreamCrypto(key: key, iv: writeIV, algorithm: .chacha20)
                }
            case .SALSA20:
                switch operation {
                case .decrypt:
                    return SodiumStreamCrypto(key: key, iv: readIV, algorithm: .salsa20)
                case .encrypt:
                    return SodiumStreamCrypto(key: key, iv: writeIV, algorithm: .salsa20)
                }
            case .RC4MD5:
                var combinedKey = Data(capacity: key.count + ivLength)
                combinedKey.append(key)
                switch operation {
                case .decrypt:
                    combinedKey.append(readIV)
                    return CCCrypto(operation: .decrypt, mode: .rc4, algorithm: .rc4, initialVector: nil, key: MD5Hash.final(combinedKey))
                case .encrypt:
                    combinedKey.append(writeIV)
                    return CCCrypto(operation: .encrypt, mode: .rc4, algorithm: .rc4, initialVector: nil, key: MD5Hash.final(combinedKey))
                }
            }
        }
    }
}
