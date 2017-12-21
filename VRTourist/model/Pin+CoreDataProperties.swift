//
//  Pin+CoreDataProperties.swift
//  VRTourist
//
//  Created by Rahul Dhiman on 21/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import CoreData

extension Pin{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin>{
        return NSFetchRequest<Pin>(entityName: "Pin")
    }
    
    @NSManaged public var long: Double
    @NSManaged public var lat: Double
    @NSManaged public var page: Int32
    @NSManaged public var image: NSSet?
    
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext){
        if let entit = NSEntityDescription.entity(forEntityName: "Pin", in: context)
        {
            self.init(entity: entit, insertInto:context)
            self.lat = latitude
            self.long = longitude
            self.page = 1
        }
        else{
            fatalError("NO ENTITY FOUND!!")
            }
        }
}

extension Pin {
    
    @objc(addImageObject:)
    @NSManaged public func addToImage(_ value: Images)
    
    @objc(removeImageObject:)
    @NSManaged public func removeFromImage(_ value: Images)
    
    @objc(addImage:)
    @NSManaged public func addToImage(_ values: NSSet)
    
    @objc(removeImage:)
    @NSManaged public func removeFromImage(_ values: NSSet)
}
