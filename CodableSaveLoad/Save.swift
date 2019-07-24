import Foundation
import PromiseKit

extension Encodable {
    
    @discardableResult public func save(url: URL, queue: DispatchQueue = .global(qos: .default), encoder: asEncoder = JSONEncoder()
        )  -> Promise<Void> {
        
        return queue.async(.promise) {
            let data = try encoder.encode(self)
            try data.write(to: url)
        }
    }
    
    @discardableResult public func save(directory: FileManager.SearchPathDirectory = .documentDirectory, name: String = "\(Self.self)", extention: String = "json", queue: DispatchQueue = .global(qos: .default), encoder: asEncoder = JSONEncoder())  -> Promise<Void> {
        do {
            let url = try createURL(from: directory, name: name, extention: extention)
            return save(url: url, queue: queue, encoder: encoder)
        } catch {
            return .init(error: error)
        }
    }
    
    @discardableResult public func saveInCache(name: String = "\(Self.self)", extention: String = "json", queue: DispatchQueue = .global(qos: .default), encoder: asEncoder = JSONEncoder())  -> Promise<Void> {
        return save(directory: .cachesDirectory, name: name, extention: extention, queue: queue, encoder: encoder)
    }
}

public protocol asEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}
extension JSONEncoder: asEncoder {}
