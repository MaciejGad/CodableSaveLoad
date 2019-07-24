import Foundation
import PromiseKit

extension Decodable {
    
    public static func load(url: URL, queue: DispatchQueue = .global(qos: .default), decoder: asDecoder = JSONDecoder())  -> Promise<Self> {
        
        return queue.async(.promise) {
            return try Data(contentsOf: url)
        }.map(on: queue) { data in
            return try decoder.decode(Self.self, from: data)
        }
    }
    
    public static func load(bundle: Bundle, name: String = "\(Self.self)", extention: String = "json", queue: DispatchQueue = .global(qos: .default), decoder: asDecoder = JSONDecoder())  -> Promise<Self> {
        guard let url = bundle.url(forResource: name, withExtension: extention) else {
            return .init(error: Errors.noFile)
        }
        return load(url: url, queue: queue, decoder: decoder)
    }
    
    public static func load(directory: FileManager.SearchPathDirectory = .documentDirectory, name: String = "\(Self.self)", extention: String = "json", queue: DispatchQueue = .global(qos: .default), decoder: asDecoder = JSONDecoder())  -> Promise<Self> {
        
        do {
            let url = try createURL(from: directory, name: name, extention: extention)
            return load(url: url, queue: queue, decoder: decoder)
        } catch {
            return .init(error: error)
        }
    }
    
    public static func loadFromCache(name: String = "\(Self.self)", extention: String = "json", queue: DispatchQueue = .global(qos: .default), decoder: asDecoder = JSONDecoder())  -> Promise<Self> {
        return load(directory: .cachesDirectory, name: name, extention: extention, queue: queue, decoder: decoder)
    }
}

public protocol asDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: asDecoder {}
