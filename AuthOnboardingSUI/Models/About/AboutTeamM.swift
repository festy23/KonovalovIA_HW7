//
//  AboutTeamM.swift
//  AboutTeamSUI9
//  Created by brfsu on 28.02.2024.
//
import CoreLocation

struct AboutTeamM {
    let name: String
    let address: String
    let person: String
    let position: String
    let phone: String
    let tg: String
    let site: String
    let email: String
    let location: LocationM
    
    static let mock = AboutTeamM(name: "CMT Lab", address: "11 Pokrovsky Boulevard", person: "Dmitry Alexandrov", position: "Head of Lab", phone: "+7(977)800-39-59", tg: "dmalex_brf", site: "https://cs.hse.ru/dse/cmt-lab/", email: "dvalexandrov@hse.ru", location: LocationM(name: "HSE University", coordinate: CLLocationCoordinate2D(latitude: 55.7522, longitude: 37.6156)))
}
