import Foundation

func createURL(from directory: FileManager.SearchPathDirectory, name: String, extention: String) throws -> URL {
    let list = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
    guard let firstPath = list.first else {
        throw Errors.noDirectory
    }
    var url = URL(fileURLWithPath: firstPath, isDirectory: true)
    url.appendPathComponent(name, isDirectory: false)
    url.appendPathExtension(extention)
    return url
}
