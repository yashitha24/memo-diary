//
//  MapView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/30/23.
//


/*
 This file defines the MapView struct, a SwiftUI view that integrates an MKMapView to display
 annotations on a map. The annotations are based on locations managed by CalendarViewModel and
 are interactive, allowing users to view details or edit associated notes or events.
 */

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: CalendarViewModel
    // Location manager for accessing user's location.
    @ObservedObject private var locationManager1 = LocationManager1()
    
    // State variables for view management and map configuration.
    @State private var isShowingNotesEditorView = false
    @State private var selectedDate = Date()
    @State private var region: MKCoordinateRegion
    @State private var annotations: [Annotation] = []
    @State private var annotationColor: UIColor = .orange
    @State private var selectedTab: Int = 0 // Assuming it’s an Int, adjust as necessary
    
    // Initializes the view with the provided viewModel and sets the initial region of the map.
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude:40.785091, longitude: -73.968285),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        // Custom UIViewRepresentable MapView with bindings and viewModel.
        MapView(region: $region, annotations: $annotations, annotationColor: $annotationColor, viewModel: viewModel)
            .onAppear {
                updateAnnotations()
            }
            .onChange(of: viewModel.locationForDates) { _ in
                updateAnnotations()
            }
        // Sheet to edit notes when an annotation is selected.
            .sheet(isPresented: $isShowingNotesEditorView) {
                NoteEditorView(viewModel: viewModel, date: selectedDate, selectedTab:$selectedTab )
            }
    }
    
    // Function to update annotations on the map based on viewModel data.
    func updateAnnotations() {
        annotations = viewModel.locationForDates.map { date, location in
            
            Annotation(
                title: DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short),
                coordinate: location.coordinate, date: date,
                onTap: {
                    print("Tap Happend")
                    self.selectedDate = date
                    self.isShowingNotesEditorView = true
                }
            )
            
        }
        
        if let firstLocation = viewModel.locationForDates.values.first {
            
            region.center = firstLocation.coordinate
            annotationColor = viewModel.loadBg(for: annotations.first?.date ?? Date())
            print("Annotation Color , \(annotationColor)")
            
        }
    }
    // Nested struct representing the UIViewRepresentable MapView.
    struct MapView: UIViewRepresentable {
        @Binding var region: MKCoordinateRegion
        @Binding var annotations: [Annotation]
        @Binding var annotationColor: UIColor
        var viewModel: CalendarViewModel
        
        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate = context.coordinator
            //            let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.longPressGesture(recognizer:)))
            //            //            longPress.minimumPressDuration = 2.0
            //            mapView.addGestureRecognizer(longPress)
            return mapView
        }
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.setRegion(region, animated: true)
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations.map({ $0.pointAnnotation }))
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self,annotationColor: annotationColor, viewModel: viewModel)
        }
        
        class Coordinator: NSObject, MKMapViewDelegate {
            var parent: MapView
            var longPressPinCount = 0
            var annotationColor: UIColor
            var viewModel: CalendarViewModel
            
            init(_ parent: MapView,annotationColor: UIColor,viewModel: CalendarViewModel) {
                self.parent = parent
                print("Annotation Color Assigning \(annotationColor)")
                self.annotationColor = annotationColor
                
                self.viewModel = viewModel
            }
            
            func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                guard let annotation = view.annotation as? MKPointAnnotation else { return }
                let annotationIndex = parent.annotations.firstIndex { $0.title == annotation.title }
                if let index = annotationIndex {
                    parent.annotations[index].onTap?()
                }
            }
            
            
            func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                let identifier = "myMarker"
                if annotation is MKUserLocation {
                    return nil
                }
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                annotationView?.markerTintColor = annotationColor
                
                return annotationView
            }
            
            
            //            @objc func longPressGesture(recognizer: UILongPressGestureRecognizer) {
            //                if recognizer.state == .began {
            //                    let touchPoint = recognizer.location(in: recognizer.view)
            //                    let touchMapCoordinate = (recognizer.view as! MKMapView).convert(touchPoint, toCoordinateFrom: recognizer.view)
            //                    longPressPinCount += 1
            //                    let newAnnotation = Annotation(title: "pin#\(longPressPinCount)", coordinate: touchMapCoordinate)
            //                    parent.annotations.append(newAnnotation)
            //                }
            //            }
        }
    }
    
    // Nested struct to define an annotation model.
    struct Annotation: Identifiable {
        var id = UUID()
        var title: String
        
        var coordinate: CLLocationCoordinate2D
        var date: Date
        var onTap: (() -> Void)?
        var pointAnnotation: MKPointAnnotation {
            let point = MKPointAnnotation()
            point.title = title
            
            point.coordinate = coordinate
            return point
        }
    }
}
