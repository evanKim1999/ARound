//
//  MainTapView.swift
//  ARound
//
//  Created by eunchanKim on 6/20/25.
//

import SwiftUI

struct MainTabView: View {
    
    enum Tab {
        case a, b, c
    }
    
    @State private var selected: Tab = .a
    
    var body: some View {
        ZStack {
            TabView(selection: $selected) {
                Group {
                    ARMapView()
                        .tabItem {
                            Image(systemName: "map")
                            Text("AR Map")
                        }
                        .tag(Tab.a)
                    MapView()
                        .tabItem {
                            Image(systemName: "location.circle")
                            Text("Map")
                        }
                        .tag(Tab.b)
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                        .tag(Tab.c)
                }
                .toolbar(.hidden, for: .tabBar)
            }
            VStack {
                Spacer()
                tabBar
                
            }
        }
    }
    
    var tabBar: some View {
        HStack {
            Spacer()
            Button {
                selected = .a
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    Text("AR")
                        .font(.system(size: 11))
                }
            }
            .foregroundStyle(selected == .a ? Color.accentColor : Color.primary)
            Spacer()
            Button {
                selected = .b
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "map")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    Text("map")
                        .font(.system(size: 11))
                }
            }
            .foregroundStyle(selected == .b ? Color.accentColor : Color.primary)
            Spacer()
            Button {
                selected = .c
            } label: {
                VStack(alignment: .center) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22)
                    Text("profile")
                        .font(.system(size: 11))
                }
            }
            .foregroundStyle(selected == .c ? Color.accentColor : Color.primary)
            Spacer()
        }
        //        .padding()
        .frame(height: 65)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MainTabView()
}
