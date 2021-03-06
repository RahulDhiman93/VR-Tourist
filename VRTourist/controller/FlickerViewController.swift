//
//  FlickerViewController.swift
//  VRTourist
//
//  Created by Rahul Dhiman on 22/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class FlickerViewController: CoreDataViewController,MKMapViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet var mapScene: MKMapView!
    @IBOutlet var NC: UIButton!
    
    
    
    var annotations = [MKPointAnnotation]()
    var pp: Pin!
    
    
    @IBAction func button(_ sender: Any) {
        NC.isEnabled = false
        let photo = (self.pp.image!) as NSSet
        for obj in photo{
            self.fetchedResultsController?.managedObjectContext.delete(obj as! NSManagedObject)
        }
        getUrls(){ (success, error) in
            DispatchQueue.main.async {
                self.NC.isEnabled = true
            }
            if success == false {
                
                DispatchQueue.main.async{
                    self.alert(error: error!)
                }
            }
            try! self.delegate.stack.saveContext()
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
       // print("i am here")
        
        let frr = NSFetchRequest<Images>(entityName:"Images")
        
       // print("yoooooo")
        frr.sortDescriptors = [NSSortDescriptor(key:"pin",ascending: true)]
        //print("what")
       let pred = NSPredicate(format: "pin = %@", argumentArray:[self.pp])
        frr.predicate = pred
        //print("hmmmmm")
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: frr, managedObjectContext: (delegate.stack.context), sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController?.delegate = self
       self.search()
        
        if (pp.image?.count)! < 1 {
          self.getUrls(){ (success, error) in
                DispatchQueue.main.async{
                    self.NC.isEnabled = true
                }
                if success == false {
                    DispatchQueue.main.async{
                        self.alert(error: error!)
                    }
                }
                try! self.delegate.stack.saveContext()
            }
        } else {
            self.NC.isEnabled = true
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("CHECK THIS OUT")
        print((pp.image?.count)!)
        
        return (pp.image?.count)!
       
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     //   print("In collection baby HCEKC OUT")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        
       // cell.FImage.alpha = 0.2
        cell.ind.isHidden = false
        cell.ind.startAnimating()
        cell.FImage.image = nil
        let obj = fetchedResultsController!.object(at: indexPath) as? Images
        if obj?.image == nil  {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async  {
                let Murl = URL(string:(obj?.url)!)
                let imagedata = try? Data(contentsOf: Murl!)
                self.fetchedResultsController?.managedObjectContext.perform{
                    obj!.image = imagedata! as NSData
                    try! self.delegate.stack.saveContext()
                    cell.FImage.image = UIImage(data:(obj?.image)! as Data)
                    cell.ind.stopAnimating()
                    cell.ind.isHidden = true
                }
            }
        }
        
        
        if obj?.image != nil {
            cell.FImage.image = UIImage(data:(obj?.image)! as Data)
            cell.ind.stopAnimating()
            cell.ind.isHidden = true
            
        }
        return cell
    }
    
    
    func  getUrls(_ completion: @escaping (_ done: Bool, _ error: String?) -> Void) {
        let flicker  = FlickerImage()
        
        //   print("GETTING URL")
        
        flicker.get(latitude: self.pp.latitude, longitude: self.pp.longitude, page: Int32(min(pp.image!.count,Int(4000/20))), completion: {
            error , urlarray in
            if error != nil
            {
               // print("NAHH")
                completion(false,error)
                return
            }
            if urlarray?.count == 0
            {
               // print("DONT KNOW")
                completion(false,"No Data Found")
                return
            }
            
            for i in urlarray!
            {
                //print("WELL HELLO THERE:")
                let im = Images(image: nil, point: self.pp, context: (self.fetchedResultsController?.managedObjectContext)!)
                im.url = i
                
                
            }
            completion(true,nil)
            
        })
        
        
    }
     
    func alert(error :String )
    {  DispatchQueue.main.async {
        
        
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler:{
            a in
            self.NC.isEnabled = true
        }))
        self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func setUp()
    {   mapScene.isUserInteractionEnabled = false
        self.NC.isEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
       let cords2d = CLLocationCoordinate2D(latitude: (self.pp?.latitude)!, longitude: (self.pp?.longitude)!)
        let annoat = MKPointAnnotation()
        annoat.coordinate = cords2d
        mapScene.addAnnotations([annoat])
        mapScene.isScrollEnabled = false
        let span = MKCoordinateSpanMake(2.3, 2.3)
        let reg = MKCoordinateRegionMake(cords2d, span)
        mapScene.setRegion(reg, animated: true)
    }

    
}
