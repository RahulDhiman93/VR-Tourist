//
//  network.swift
//  VRTourist
//
//  Created by Rahul Dhiman on 20/12/17.
//  Copyright © 2017 Rahul Dhiman. All rights reserved.
//

import Foundation
import UIKit

struct FlickerImage
{
    
    let scheme = "https"
    let host = "api.flickr.com"
    let path = "/services/rest"
    
    
    func get(latitude:Double, longitude:Double,page:Int32, completion:@escaping (_ error:String?,_ data:[String]?)->())
    {
        
        let url = "https://api.flickr.com/services/rest?page=\(page)&method=flickr.photos.search&format=json&api_key=a70bee7297e31fa3487ef2de75121400&bbox=\(bbox(Lat:latitude, Long:longitude))&extras=url_m&nojsoncallback=1"
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: URL(string: url)!){data,response,error in
            if error != nil {
                completion(error?.localizedDescription, nil)
                return
            }
            
            let Data = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            
            if let pics = Data["photos"] as? [String:Any], let array = pics["photos"] as? [[String:Any]]
            {
                var count = array.count - 1
                
                var urlarray = [String]()
                
                if count > 20
                {
                    count = 20
                }
                
                while count > 0 {
                    
                    count-=1
                    let obj = array[count]
                    var url = obj["url_m"] as! String
                    urlarray.append(url)
                    
                }
                completion(nil,urlarray)
            }
        }
        task.resume()
        
    }
    
   
    
    
    
    
    
    func bbox(Lat:Double,Long:Double)->String{
        
        let minLong = min(Long + 1,180)
        let maxLong = max(Long - 1,-180)
        let minLat = min(Lat + 1, 90)
        let maxLat = max(Lat - 1, -90)
        
        return "\(maxLong),\(maxLat),\(minLong),\(minLat)"
        
        
    }
    
    
    
}
