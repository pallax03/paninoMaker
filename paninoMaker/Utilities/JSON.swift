//
//  JSONLoader.swift
//  paninoMaker
//
//  Created by alex mazzoni on 27/05/25.
//

import Foundation

func decodeJSON<T: Decodable>(_ filename: String) -> T {
    guard
        let url = Bundle.main.url(forResource: filename, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let content = try? JSONDecoder().decode(T.self, from: data)
    else {
        fatalError("File not found: \(filename).json")
    }
    return content
}

func codeJSON<T: Encodable>(_ value: T) -> String {
    let data = try! JSONEncoder().encode(value)
    return String(data: data, encoding: .utf8)!
}
