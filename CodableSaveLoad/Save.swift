import Foundation
import PromiseKit

extension Encodable {
    @discardableResult public func save(
        name: String = "\(Self.self)",
        extention: String = "json",
        urlCreator: (String, String) throws -> URL = documentUrl(name:extention:),
        queue: DispatchQueue = .global(qos: .default),
        encoder: asEncoder = JSONEncoder()
        )  -> Promise<Void> {
        
            return Promise<URL> { seal in
                let url = try urlCreator(name, extention)
                seal.fulfill(url)
                }.map(on: queue) { url in
                    let data = try encoder.encode(self)
                    try data.write(to: url)
            }
        }
}

public protocol asEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}
extension JSONEncoder: asEncoder {}
