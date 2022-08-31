//
//  ViewController.swift
//  Project16
//
//  Created by DongKyu Kim on 2022/08/31.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        let seoul = Capital(title: "Seoul", coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), info: "The Hot Place where Gangnam style has born")
        
//        mapView.addAnnotation(london)
//        mapView.addAnnotation(oslo)
//        mapView.addAnnotation(paris)
//        mapView.addAnnotation(rome)
//        mapView.addAnnotation(washington)
        mapView.addAnnotations([london, oslo, paris, rome, washington, seoul])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(selectOption))
    }
    
    @objc func selectOption() {
        let ac = UIAlertController(title: "Select Map Type Option", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "standard", style: .default) { _ in
            self.mapView.mapType = .standard
        })
        
        ac.addAction(UIAlertAction(title: "hybrid", style: .default) { _ in
            self.mapView.mapType = .hybrid
        })
        
        ac.addAction(UIAlertAction(title: "hybridFlyover", style: .default) { _ in
            self.mapView.mapType = .hybridFlyover
        })
        
        ac.addAction(UIAlertAction(title: "mutedStandard", style: .default) { _ in
            self.mapView.mapType = .mutedStandard
        })
        
        ac.addAction(UIAlertAction(title: "satellite", style: .default) { _ in
            self.mapView.mapType = .satellite
        })
        
        ac.addAction(UIAlertAction(title: "satelliteFlyover", style: .default) { _ in
            self.mapView.mapType = .satelliteFlyover
        })
        
        present(ac, animated: true)
        
    }

}

extension ViewController: MKMapViewDelegate {
    // custom annotation 띄우기
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }
        
        // 2
        let identifier = "Capital"
        
        // 3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            // 4
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemCyan
            
            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // alert를 통해 세부 정보 표시
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        guard let capital = view.annotation as? Capital else { return }
//        let placeName = capital.title
//        let placeInfo = capital.info
//
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//    }
    
    // WebView - WikiPedia 찾기
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            vc.url = URL(string: "https://en.wikipedia.org/wiki/\(placeName ?? "")")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

