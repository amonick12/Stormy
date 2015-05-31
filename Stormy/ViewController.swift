//
//  ViewController.swift
//  Stormy
//
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationName: UILabel?
    @IBOutlet weak var currentWeatherSummary: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var refreshButton: UIButton?
    
    private let forecastAPIKey = "e93e19ee5f4c43d7d4987bc0c9c116de"
    //let coordinate: (lat: Double, long: Double) = (37.8267,-122.423)
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue : CLLocationCoordinate2D = manager.location.coordinate
        println("Long: \(locValue.longitude)\nLat: \(locValue.latitude)")
        locationManager.stopUpdatingLocation()
        
        getLocationName(manager.location)
        getWeatherData(locValue.latitude, long: locValue.longitude)
        
    }
    
    func getLocationName(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            //println(location)
            
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                let locationName = pm.locality
                println(locationName)
                self.locationName?.text = locationName
                
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })

    }
    
    func getWeatherData(lat: Double, long: Double) {
        
        let forecastService = ForcastService(APIKey: forecastAPIKey)
        
        forecastService.getForcast(lat, long: long) {
            (let currently) in
            if let currentWeather = currently {
                // update UI
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    if let precipProbability = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipProbability)%"
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }
                    
                    self.toggleRefreshAnimation(false)

                }
            }
            
        }
        
    }
    
    @IBAction func refreshWeather(sender: AnyObject) {
        toggleRefreshAnimation(true)
        locationManager.startUpdatingLocation()
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

