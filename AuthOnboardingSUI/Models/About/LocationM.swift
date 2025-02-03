//
//  LocationM.swift
//  AboutTeamSUI9
//  Created by brfsu on 28.02.2024.
//
import CoreLocation

struct LocationM: Identifiable
{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

