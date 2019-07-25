import Foundation
import PromiseKit

extension Encodable {
    
    @discardableResult public static func delete(url: URL, queue: DispatchQueue = .global(qos: .default))  -> Promise<Void> {

        guard url.isFileURL else {
            return .init(error: Errors.notFileURL)
        }
        return queue.async(.promise) {
            let manager = FileManager.default
            try manager.removeItem(at: url)
        }
    }
    
    @discardableResult public static func delete(directory: FileManager.SearchPathDirectory = .documentDirectory, name: String = "\(Self.self)", extention: String = "json", queue: DispatchQueue = .global(qos: .default)) -> Promise<Void> {
        do {
            let url = try createURL(from: directory, name: name, extention: extention)
            return delete(url: url, queue: queue)
        } catch {
            return .init(error: error)
        }
    }
    
    @discardableResult public static func deleteFromCache(name: String = "\(Self.self)", extention: String = "json", queue: DispatchQueue = .global(qos: .default))  -> Promise<Void> {
        return delete(directory: .cachesDirectory, name: name, extention: extention, queue: queue)
    }
}
