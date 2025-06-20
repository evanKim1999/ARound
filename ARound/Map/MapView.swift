//
//  MapView.swift
//  ARound
//
//  Created by eunchanKim on 6/20/25.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), // 서울
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    @State private var selectedLocation: Location?

    let locations = [
        Location(name: "경복궁", coordinate: CLLocationCoordinate2D(latitude: 37.5796, longitude: 126.9770)),
        Location(name: "남산타워", coordinate: CLLocationCoordinate2D(latitude: 37.5512, longitude: 126.9882))
    ]

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(locations) { location in
                Annotation(location.name, coordinate: location.coordinate) {
                    VStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                selectedLocation = location
                            }
                        Text(location.name)
                            .font(.caption2)
                    }
                }
            }
        }
        .mapStyle(.standard)
        .sheet(item: $selectedLocation) { location in
            BottomSheetView(location: location)
                .presentationDetents([.medium, .large])
                .presentationBackground(.thickMaterial)//(.thinMaterial)
                .presentationBackgroundInteraction (.enabled)
        }
    }
}

struct BottomSheetView: View {
    let location: Location

    var body: some View {
        VStack(spacing: 20) {
            Text("📍 \(location.name)")
                .font(.title2)
                .bold()
            Text("위도: \(location.coordinate.latitude)")
            Text("경도: \(location.coordinate.longitude)")
        }
        .padding()
    }
}

#Preview {
    MapView()
}
