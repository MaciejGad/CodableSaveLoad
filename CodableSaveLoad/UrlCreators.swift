import Foundation

func documentUrl(name: String, extention: String) throws -> URL {
    return try userDirectory(.documentDirectory, name: name, extention: extention)
}

func cacheUrl(name: String, extention: String) throws -> URL {
    return try userDirectory(.cachesDirectory, name: name, extention: extention)
}

func userDirectory(_ directory: FileManager.SearchPathDirectory, name: String, extention: String) throws -> URL {
    let list = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
    guard let firstPath = list.first else {
        throw Errors.noDirectory
    }
    var url = URL(fileURLWithPath: firstPath, isDirectory: true)
    url.appendPathComponent(name, isDirectory: false)
    url.appendPathExtension(extention)
    return url
}

extension Bundle {
    func file(name: String, extention: String) throws -> URL {
        guard let url = self.url(forResource: name, withExtension: extention) else {
            throw Errors.noFile
        }
        return url
    }
}
