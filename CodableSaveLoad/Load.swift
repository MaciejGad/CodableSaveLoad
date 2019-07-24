import Foundation
import PromiseKit

extension Decodable {
    public static func load(
        name: String = "\(Self.self)",
        extention: String = "json",
        urlCreator: (String, String) throws -> URL = documentUrl(name:extention:),
        queue: DispatchQueue = .global(qos: .default),
        decoder: asDecoder = JSONDecoder()
        )  -> Promise<Self> {
        
        return Promise<URL> { seal in
            let url = try urlCreator(name, extention)
            seal.fulfill(url)
            }.map(on: queue) { (url: URL) -> Data in
                try Data(contentsOf: url)
            }.map(on: queue) {
                return try decoder.decode(Self.self, from: $0)
        }
    }
}

public protocol asDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: asDecoder {}
