import Foundation

enum Constants {
    static let bbName = "Breaking Bad"
    static let bcsName = "Better Call Saul"

    static let previewCharacter: Character = {
        let decoder = JSONDecoder()

        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let data = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)

        return try! decoder.decode([Character].self, from: data)[0]
    }()
}

extension String {
    var replaceSpaceWithPlus: String {
        replacingOccurrences(of: " ", with: "+")
    }

    var noSpaces: String {
        replacingOccurrences(of: " ", with: "")
    }

    var lowerNoSpaces: String {
        noSpaces.lowercased()
    }
}
