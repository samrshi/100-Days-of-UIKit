//
//  FileManager+docsDirectory.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/8/21.
//

import Foundation

extension FileManager {
  static func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
