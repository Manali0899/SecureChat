import Foundation
import Network
import Security

// MARK: - Keychain Helper
func saveToKeychain(key: String, value: String) {
    let data = value.data(using: .utf8)!
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecValueData as String: data
    ]
    SecItemDelete(query as CFDictionary) // remove old
    SecItemAdd(query as CFDictionary, nil)
}

func readFromKeychain(key: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    if status == errSecSuccess, let data = dataTypeRef as? Data {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

// MARK: - History
struct History {
    static let path = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".securechat/history.txt").path
    
    static func append(_ msg: String) {
        try? FileManager.default.createDirectory(
            atPath: (path as NSString).deletingLastPathComponent,
            withIntermediateDirectories: true
        )
        if FileManager.default.fileExists(atPath: path) {
            if let handle = FileHandle(forWritingAtPath: path) {
                handle.seekToEndOfFile()
                handle.write("\(msg)\n".data(using: .utf8)!)
                handle.closeFile()
            }
        } else {
            try? "\(msg)\n".write(toFile: path, atomically: true, encoding: .utf8)
        }
    }
}

// MARK: - ChatClient
final class ChatClient: @unchecked Sendable {
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    private var connection: NWConnection?
    
    init(host: String, port: UInt16) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)!
    }
    
    func connect(completion: @escaping @Sendable (Bool) -> Void) {
        let conn = NWConnection(host: host, port: port, using: .tcp)
        self.connection = conn
        conn.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .ready:
                print("✅ Connected to \(self.host):\(self.port)")
                completion(true)
                self.receiveLoop()
            case .failed(let error):
                print("❌ Connection failed: \(error)")
                completion(false)
            default:
                break
            }
        }
        conn.start(queue: .global(qos: .userInitiated))
    }
    
    private func receiveLoop() {
        guard let conn = connection else { return }
        conn.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] data, _, isComplete, error in
            guard let self = self else { return }
            if let data = data, !data.isEmpty {
                let str = String(decoding: data, as: UTF8.self)
                print("← \(str)")
                History.append("Server: \(str)")
            }
            if isComplete == false && error == nil {
                self.receiveLoop()
            }
        }
    }
    
    func send(_ msg: String) {
        guard let conn = connection else { return }
        let data = msg.data(using: .utf8)!
        conn.send(content: data, completion: .contentProcessed { _ in })
        History.append("Me: \(msg)")
    }
    
    func disconnect() {
        connection?.cancel()
        connection = nil
    }
}

// MARK: - Entry Point
print("=== SecureChat (macOS CLI) ===")
print("Username:", terminator: " ")
let username = readLine() ?? "guest"
print("Password:", terminator: " ")
let password = readLine() ?? ""
saveToKeychain(key: username, value: password)
print("🔐 Saved to Keychain.")

let client = ChatClient(host: "127.0.0.1", port: 65432)

let semaphore = DispatchSemaphore(value: 0)
client.connect { ok in
    if ok {
        semaphore.signal()
    } else {
        exit(1)
    }
}
_ = semaphore.wait(timeout: .now() + 5)

while true {
    if let input = readLine() {
        if input == "/quit" {
            client.disconnect()
            break
        }
        client.send("[\(username)] \(input)")
    }
    
}
