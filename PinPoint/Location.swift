//
//  Location.swift
//  PinPoint
//
//  Created by Grant Maloney on 9/13/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

let key: String = "pOqC1xUOk44a5v7WYvGDg5GUtiekzYqC"

class Location {
    
    let city: String
    let state: String
    let business: Int
    
    init(city: String, state: String, business: Int) {
        self.city = city
        self.state = state
        self.business = business
    }
    
    var urlString: String {
        return "https://www.mapquestapi.com/search/v2/radius"
    }
    
    func getData(completion: @escaping([HotSpot]) -> ()) {
        var urlComponents: URLComponents = URLComponents(string: urlString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "origin", value: "\(city),\(state)"),
            URLQueryItem(name: "radius", value: "5"),
            URLQueryItem(name: "maxMatches", value: "25"),
            URLQueryItem(name: "hostedData", value: "mqap.ntpois|group_sic_code ILIKE ?|\(business)|")
        ]
        
        guard let url: URL = urlComponents.url else {
            print("returning")
            return
        }
        
        var hotSpots = [HotSpot]()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }
            let locationData = try? JSONDecoder().decode(LocationData.self, from: data)
            
            for result in (locationData?.searchResults)! {
                hotSpots.append(HotSpot(lat: result.fields.dispLat, lng: result.fields.dispLng, name: result.name, address: "\(result.fields.address), \(result.fields.city), \(result.fields.state)"))
            }
            completion(hotSpots)
        }.resume()
    }
    
//    let pinpoint: CLLocation() = {
//        return CL
//    }
}

struct HotSpot {
    let lat: Double
    let lng: Double
    let name: String
    let address: String
}
