//
//  LyricEntity+CoreDataProperties.swift
//  LyricsApp
//
//  Created by Obed Garcia on 6/2/22.
//
//

import Foundation
import CoreData


extension LyricEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LyricEntity> {
        return NSFetchRequest<LyricEntity>(entityName: "LyricEntity")
    }

    @NSManaged public var artist: String?
    @NSManaged public var id: String?
    @NSManaged public var songTitle: String?
    @NSManaged public var lyrics: String?

}

extension LyricEntity : Identifiable {

}
