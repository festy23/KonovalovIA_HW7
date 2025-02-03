//
//  ScreenScr.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import SwiftUI
import MapKit

struct AboutS: View {
    var model: AboutTeamM
    
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                    .font(.title)
                Spacer()
            }
            .padding()
            
            VStack {
                HStack {
                    Text("Contacts")
                        .font(.title2)
                    Spacer()
                }
                
                HStack {
                    Text("Name")
                    Spacer()
                    Text(model.person)
                }
                
                HStack {
                    Text("Position")
                    Spacer()
                    Text(model.position)
                }
                
                HStack {
                    Text("Address")
                    Spacer()
                    Text(model.address)
                }
                
                HStack {
                    Text("Phone")
                    Spacer()
                    Link(model.phone, destination: URL(string: "tel://\(model.phone)")!)
                }
                
                HStack {
                    Text("Telegram")
                    Spacer()
                    Link("@\(model.tg)", destination: URL(string: "tg://\(model.tg)")!)
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Link(model.email, destination: URL(string: "mailto://\(model.email)")! )
                }
                
                HStack {
                    Text("Website")
                    Spacer()
                    NavigationLink(model.site) {
                        SafariV(url: URL(string: model.site)!)
                    }
                }
            }
            .padding(.horizontal)
            MapV(model: model)
        }
            .navigationBarTitle("About Team", displayMode: .inline)
            .navigationTitle("About Team")
            .padding(.horizontal)
        
        
//        }
//        .padding(.top)
//        .ignoresSafeArea()
    }
}
