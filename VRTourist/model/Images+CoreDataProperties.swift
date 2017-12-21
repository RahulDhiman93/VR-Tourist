//
//  Images+CoreDataProperties.swift
//  VRTourist
//
//  Created by Rahul Dhiman on 21/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import CoreData

extension Images{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }
    
    @NSManaged public var image: NSData?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?
    
    convenience init(image:NSData?, point: Pin, context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "Images", in: context){
            self.init(entity: ent, insertInto: context)
            self.image = image
            self.pin = point
        
            
        }
        else{
            fatalError("NO ENTITY FOUND!!")
        }
    }
}
