import Foundation
import PromiseKit

extension Encodable {
    
    @discardableResult public static func delete(
        name: String = "\(Self.self)",
        extention: String = "json",
        urlCreator: (String, String) throws -> URL = documentUrl(name:extention:),
        queue: DispatchQueue = .global(qos: .default)
        )  -> Promise<Void> {
        
        return Promise<URL> { seal in
            let url = try urlCreator(name, extention)
            seal.fulfill(url)
            }.then { url -> Promise<Void> in
                guard url.isFileURL else {
                    throw Errors.notFileURL
                }
                return queue.async(.promise) {
                    let manager = FileManager.default
                    try manager.removeItem(at: url)
                }
        }
    }
}
