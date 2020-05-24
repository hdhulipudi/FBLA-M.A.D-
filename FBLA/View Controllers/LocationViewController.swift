//
//  LocationViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 5/24/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import LocationPicker
import CoreLocation
import MapKit

class LocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let locationPicker = LocationPickerViewController()
        
        // you can optionally set initial location
        let location = CLLocation(latitude: 35, longitude: 35)
        let placemark = MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: 2, longitude: 3), addressDictionary: [:])
        let initialLocation = Location(name: "My home", location: location, placemark:  placemark)
        locationPicker.location = initialLocation

        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true

        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.currentLocationButtonBackground = .blue

        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true

        locationPicker.mapType = .standard // default: .Hybrid

        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false

        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"

        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"

        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600

        locationPicker.completion = { location in
            // do some awesome stuff with location
        }

        navigationController?.pushViewController(locationPicker, animated: true)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
