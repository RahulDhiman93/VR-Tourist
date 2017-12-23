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
    
    func get(latitude:Double, longitude:Double,page:Int32, completion:@escaping (_ error:String?,_ data:[String]?)->())
    {
        
        let url = "https://api.flickr.com/services/rest?page=\(page)&method=flickr.photos.search&format=json&api_key=a70bee7297e31fa3487ef2de75121400&bbox=\(bbox(Lat:latitude, Long:longitude))&extras=url_m&nojsoncallback=1"
        
      //  print("URL IS  : ")
       // print(url)
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: URL(string: url)!){data,response,error in
            if error != nil {
              //  print("erroe SIR")
                completion(error?.localizedDescription, nil)
                return
            }
            
           // print("ABOVE DATA")
            
            let Data = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
            
            
            //print(Data)

            //print("UTTE DATTA SI")
            
            if let pics = Data["photos"] as? [String:Any] ,let array = pics["photo"] as? [[String:Any]]
            {
                
              //  print("DOWNLOADING")
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
            else{
                //print("TUHADE TO NE HONNA")
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
