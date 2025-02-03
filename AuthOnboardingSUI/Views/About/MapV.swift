//
//  MapV.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import MapKit

struct MapV: View
{
    var model: AboutTeamM
    
    var body: some View {
        Map() {
            Marker(coordinate: model.location.coordinate) {
                Label(model.location.name, systemImage: "mappin")
            }
        }
        .containerRelativeFrame(.horizontal, count: 4, span: 10, spacing: 10)
        .navigationBarTitle("About team", displayMode: .inline)
    }
}
