//
//  ProfileView.swift
//  ARound
//
//  Created by eunchanKim on 6/20/25.
//

import SwiftUI

struct ProfileView: View {
    let images = ["애플스토어", "경복궁"]
    
    var body: some View {
        VStack {
            Image("테일러스위프트")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.top, 25)
                .padding(.horizontal, 10)
            
            Text("Taylor swift")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 14)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("5")
                        .font(.system(size: 14, weight: .bold))
                    Text("Posts")
                        .font(.system(size: 14))
                }
                .padding(.trailing, 30)
                
                VStack(alignment: .leading) {
                    Text("123")
                        .font(.system(size: 14, weight: .bold))
                    Text("Followers")
                        .font(.system(size: 14))
                }
                .padding(.trailing, 30)
                
                VStack(alignment: .leading) {
                    Text("12")
                        .font(.system(size: 14, weight: .bold))
                    Text("Visited")
                        .font(.system(size: 14))
                }
                
            }
            .padding(.bottom, 16)
            
            
            HStack {
                Button {
                    
                } label: {
                    Text("Edit Profile")
                        .font(.custom("SettlementLabel", size: 12))
                        .frame(width: 104, height: 28.75) // 버튼 크기 고정
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.trailing, 18)
                Button {
                    
                } label: {
                    Text("Share Profile")
                        .font(.custom("SettlementLabel", size: 12))
                        .frame(width: 104, height: 28.75) // 버튼 크기 고정
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.trailing, 18)
                Button {
                    
                } label: {
                    Image(systemName: "person.badge.plus")
                        .frame(width: 30, height: 28.75) // 버튼 크기 고정
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.bottom, 16)
            
            Text("Recent Visits")
                .font(.system(size: 24, weight: .bold))
                .padding(.bottom, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(images, id: \.self) { imageName in
                        Button {
                            print("\(imageName) tapped")
                            // 원하는 동작을 여기서 실행
                        } label: {
                            VStack {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:180, height: 300)
                                    .clipped()
                                    .cornerRadius(16)
                                    .shadow(radius: 4)
                                
                                Text("Location")
                                    
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // 버튼 효과 제거
                    }
                }
                .padding(.horizontal)
            }
            Spacer()

        }
    }
}

#Preview {
    ProfileView()
}
