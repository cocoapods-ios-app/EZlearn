//
//  LearningGoal+CoreDataProperties.swift
//  
//
//  Created by Sharonda Daniels on 11/9/22.
//
//

import Foundation
import CoreData


extension LearningGoal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LearningGoal> {
        return NSFetchRequest<LearningGoal>(entityName: "LearningGoal")
    }

    @NSManaged public var colorIndex: Int64
    @NSManaged public var name: String?
    @NSManaged public var resourceDictionary: NSObject?
    @NSManaged public var resources: String?

}
