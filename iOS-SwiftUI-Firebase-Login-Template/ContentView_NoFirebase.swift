//
//  ContentView_NoFirebase.swift
//  iOS-SwiftUI-Firebase-Login-Template
//
//  Created by Tina Nigro on 11/09/2023.
//

import SwiftUI
import MapKit

struct ContentView_NoFirebase: View {
    @State private var selectedView = 0
    @State private var selectedFilter = 0
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var sampleVenues: [Venue] = [
        Venue(name: "Cafe Zero", coordinate: CLLocationCoordinate2D(latitude: 48.8560, longitude: 2.3520), drinkType: .mocktails),
        Venue(name: "The Sober Pub", coordinate: CLLocationCoordinate2D(latitude: 48.8570, longitude: 2.3530), drinkType: .bottleBeer),
        Venue(name: "Healthy Sips", coordinate: CLLocationCoordinate2D(latitude: 48.8580, longitude: 2.3540), drinkType: .wines)
    ]

    var filteredVenues: [Venue] {
        sampleVenues.filter { selectedFilter == 0 || $0.drinkType.rawValue == selectedFilter }
    }

    var body: some View {
        ZStack {
            // Map or List View
            if selectedView == 0 {
                Map(initialPosition: .camera(MapCamera(centerCoordinate: region.center, distance: 500, heading: 0, pitch: 50)), interactionModes: [.all]) {
                    ForEach(filteredVenues) { venue in
                        Annotation(venue.name, coordinate: venue.coordinate, anchor: .bottom) {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.cyan.opacity(0.5))
                                    .frame(width: 80, height: 80)

                                Image(systemName: "wineglass")
                                    .symbolEffect(.variableColor)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(Color.cyan)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic, pointsOfInterest: [.publicTransport]))
                .edgesIgnoringSafeArea(.all)
                .onAppear {

                }
            } else {
                List(filteredVenues, id: \.name) { venue in
                    Text(venue.name)
                }
            }

            VStack {
                Spacer()

                HStack {
                    // Map/List Toggle Button
                    // Map/List Toggle Button
                    Button(action: {
                        selectedView = selectedView == 0 ? 1 : 0
                    }) {
                        Image(systemName: selectedView == 0 ? "map" : "list.bullet")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(30)
                    }

                    Spacer()

                    // Beverage Type Picker
                    Picker("Preferred Drink", selection: $selectedFilter) {
                        Text("All").tag(0)
                        Text("Mocktails").tag(1)
                        Text("Bottle Beer").tag(2)
                        Text("Tap Beer").tag(3)
                        Text("Wines").tag(4)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 150)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Spacer()

                    // Floating Action Button
                    Button(action: {
                        // Add new venue action
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .overlay(
            // Search Bar
            TextField("Search for venues...", text: .constant(""))
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top),
            alignment: .top
        )
    }
}

enum DrinkType: Int {
    case mocktails = 1
    case bottleBeer = 2
    case tapBeer = 3
    case wines = 4
}

struct Venue: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let drinkType: DrinkType
}

#Preview {
    ContentView_NoFirebase()
}
