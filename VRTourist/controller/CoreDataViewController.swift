//
//  CoreDataViewController.swift
//  VRTourist
//
//  Created by Rahul Dhiman on 22/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoreDataViewController: UIViewController,UICollectionViewDelegate {


    @IBOutlet var collectionView: UICollectionView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    var deleted = [IndexPath]()
    
    var updated = [IndexPath]()
    
    var insert = [IndexPath]()
    
    var fetchedResultsController : NSFetchedResultsController<Images>?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func search(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch {
                print("error")
            }
        }
    }
    
    func numberOfSection(_ collectionView: UICollectionView) -> Int{
        if let cnt = self.fetchedResultsController{
            return (cnt.sections?.count)!
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)->Int{
        if let SC = self.fetchedResultsController!.sections{
            return SC[section].numberOfObjects
        }
        return 0
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView:UICollectionView,didSelectItemAt indexPath:IndexPath){
        
        if let fc = self.fetchedResultsController{
            fc.managedObjectContext.delete((fetchedResultsController?.object(at: indexPath))! as NSManagedObject)
            try! self.delegate.stack.saveContext()
            DispatchQueue.main.async {
                
                
                self.collectionView.reloadData()
                
            }
            
        
        }
    }
    
}

extension CoreDataViewController:NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
       
        self.insert  = [IndexPath]()
        self.deleted = [IndexPath]()
        self.updated = [IndexPath]()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            self.deleted.append(indexPath!)
            break
        case .insert:
            self.insert.append(newIndexPath!)
            break
        case .update:
            self.updated.append(indexPath!)
            break
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.performBatchUpdates({ () -> Void in
            for i in self.updated {
                self.collectionView.reloadItems(at: [i])
            }
            for i in self.insert {
                self.collectionView.insertItems(at: [i])
            }
            for i in self.deleted {
                self.collectionView.deleteItems(at: [i])
            }
            
        }, completion: nil)
        
        
    }
}
