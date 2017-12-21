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
    
    let fetchedResultt = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.loadData()
        
    }
    
    @objc func PinIT(_ pressure : UILongPressGestureRecognizer)
    {
        if pressure.state == UIGestureRecognizerState.began
        {
            let location = pressure.location(in: mapview)
            let cc = mapview.convert(location, toCoordinateFrom: mapview)
            let Ann = MKPointAnnotation()
            Ann.coordinate = cc
          //  let _ = Pin(latitude: cc.latitude, longitude: cc.longitude, context: (fetchedResultsController?.managedObjectContext)!)
            try! stack.saveContext()
            loadData()
            
            
        }
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        var ppoint: NSManagedObject!
        let pp1 = NSPredicate(format: "lat = %@",argumentArray:[(view.annotation?.coordinate.latitude)!])
        let pp2 = NSPredicate(format: "long = %@",argumentArray:[(view.annotation?.coordinate.longitude)!])
        let FetchedResult2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let PredicateR = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [pp1,pp2])
        
        FetchedResult2.predicate = PredicateR
        FetchedResult2.sortDescriptors = [NSSortDescriptor(key: "lat",ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: FetchedResult2, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
       fetchDue(fetchedResultsController: fetchedResultsController, completion: {
            
     
            let object = fetchedResultsController?.fetchedObjects as! [NSManagedObject]
            ppoint = object[0]
        })
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        performSegue(withIdentifier: "SG", sender: ppoint)
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        
      //  let sg = segue.destination as! FlickerViewController
        // sg.point = sender as! PIN
        
        
    }
    
}

extension MapSceneViewController {
   
    func loadData(){
        fetchedResultt.sortDescriptors = [NSSortDescriptor(key: "lat", ascending: false),NSSortDescriptor(key: "long",ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedResultt, managedObjectContext: stack.context, sectionNameKeyPath:nil, cacheName: nil)
        
        fetchDue(fetchedResultsController: fetchedResultsController, completion: {
            
           // let p:[Pin] = fetchedResultsController?.fetchedObjects as! [Pin]
            
            let p:[Pin] = fetchedResultsController?.fetchedObjects as! [Pin]
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                var an = [MKPointAnnotation]()
                for a in p
                {
                    let anno = MKPointAnnotation()
                    //  anno.coordinate = CLLocationCoordinate2D(latitude: a.lat, longtitude: a.long)
                    an.append(anno)
                }
                
            
            
            DispatchQueue.main.async {
                self.mapview.addAnnotations(an)
            }
        }
    })
        
    }
    
    
    func setUp(){
        mapview.delegate = self
        let pressure = UILongPressGestureRecognizer(target:self, action: #selector(PinIT(_:)))
        pressure.delegate = self
        pressure.minimumPressDuration = 0.7
        pressure.allowableMovement = 1
        mapview.addGestureRecognizer(pressure)
    }
    
    func fetchDue(fetchedResultsController :  NSFetchedResultsController<NSFetchRequestResult>?, completion:()->())
    {
      fetchedResultsController?.delegate = self as? NSFetchedResultsControllerDelegate
        
        search()
        completion()
        
    }
    
    func search(){
        if let fetchC = fetchedResultsController{
            do{
                try fetchC.performFetch()
            }
            catch let e as NSError{
                print("error in \(e)")
                
            }
        }
        
    }
    
}
