//
//  MapSceneViewController.swift
//  VRTourist
//
//  Created by Rahul Dhiman on 20/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit
import CoreData
import MapKit

let delegate = UIApplication.shared.delegate as! AppDelegate

class MapSceneViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var mapview: MKMapView!
    let stack = delegate.stack
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?
    
    let fetchedResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setup()
        //self.loadData()
        
    }
    
    func PinIT(_ pressure : UILongPressGestureRecognizer)
    {
        if pressure.state == UIGestureRecognizerState.began
        {
            let location = pressure.location(in: mapview)
            let cc = mapview.convert(location, toCoordinateFrom: mapview)
            let Ann = MKPointAnnotation()
            Ann.coordinate = cc
          //  let _ = PIN(latitude: cc.latitude, longitude: cc.longitude, context: (fetchedResultsController?.managedObjectContext)!)
            try! stack.saveContext()
            //loadData()
            
            
        }
    }
    
    public func MapScene(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        var ppoint: NSManagedObject!
        let pp1 = NSPredicate(format: "lat = %@",argumentArray:[(view.annotation?.coordinate.latitude)!])
        let pp2 = NSPredicate(format: "long = %@",argumentArray:[(view.annotation?.coordinate.longitude)!])
        let FetchedResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let PredicateR = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [pp1,pp2])
        
        FetchedResult.predicate = PredicateR
        FetchedResult.sortDescriptors = [NSSortDescriptor(key: "lat",ascending: true)]
        
        
        
    }
    

    

}
