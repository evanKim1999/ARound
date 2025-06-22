//
//  MapView.swift
//  ARound
//
//  Created by eunchanKim on 6/20/25.
//

import SwiftUI
import MapKit

enum PinStyle: String, Codable {
    case user
    case place
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let style: PinStyle
}

struct MapView: View {
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5796, longitude: 126.9770), // 서울
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    @State private var detent: PresentationDetent = .fraction(0.65)  // 초기 크기 65
    @State private var selectedLocation: Location?
    @State private var selectedIndex = 0
    @State private var searchText = ""
    @State private var locations: [Location] = [ Location(name: "경복궁", coordinate: CLLocationCoordinate2D(latitude: 37.5796, longitude: 126.9770), style: .place),
                                                 Location(name: "남산타워", coordinate: CLLocationCoordinate2D(latitude: 37.5512, longitude: 126.9882), style: .place),
                                                 Location(name: "Swift", coordinate: CLLocationCoordinate2D(latitude: 37.5612, longitude: 126.9872), style: .user)]
    
    var body: some View {
        ZStack (alignment: .top) {
            // 지도
            Map(position: $cameraPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        pinView(for: location)
                            .onTapGesture {
                                selectedLocation = location
                            }
                    }
                }
            }
            .mapStyle(.standard)
            //            .sheet(item: $selectedLocation) { location in
            //                BottomSheetView(location: location, detent: $detent)
            //                    .presentationDetents([.fraction(0.35), .large], selection: $detent)
            //                    .presentationDragIndicator(.visible)
            //                    .presentationBackground(.thickMaterial)
            //                    .presentationBackgroundInteraction (.enabled)
            //                    .onDisappear {
            //                        // ✅ 시트 닫을 때 초기화
            //                        detent = .fraction(0.35)
            //                    }
            LocationPagerSheet(locations: locations, selectedIndex: $selectedIndex)
            //                    .presentationDetents([.fraction(0.35), .large])
            //                    .presentationDragIndicator(.visible)
            //                    .presentationBackground(.clear)
            //            }
            
            // 플로팅 검색 바
            VStack(alignment: .leading){
                CustomSearchBar(text: $searchText) {
                    searchForLocation(named: searchText)
                }
                .padding(.top, 20) // 상단 여백 조정 (SafeArea용)
                
                Button {
                    
                } label: {
                    HStack(alignment: .center) {
                        
                        Ellipse()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.red)
                        
                        Text("LIVE")
                            .font(.system(size: 12 , weight: .bold))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                        
                    }
                    .frame(width: 51, height: 26) // 버튼 크기 고정
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 4) // ✅ 아래쪽 그림자
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
    
    // ⛳️ 위치 검색
    func searchForLocation(named name: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = name
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate,
                  let name = response?.mapItems.first?.name else {
                return
            }
            
            let found = Location(name: name, coordinate: coordinate, style: .place)
            locations = [found]
            
            cameraPosition = .region(MKCoordinateRegion(center: coordinate,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
        }
    }
    
    @ViewBuilder
    func pinView(for location: Location) -> some View {
        switch location.style {
        case .place:
            VStack(spacing: 0) {
                Text("📍")
                    .font(.system(size: 40))
                Text(location.name)
                    .font(.caption2)
                    .padding(4)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(6)
            }
        case .user:
            ZStack(alignment: .bottomTrailing) {
                // 말풍선 본체
                Image("테일러스위프트")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 77, height: 77)
                    .clipShape(SpeechBubbleShape())
                    .shadow(color: .red, radius: 4)
                
                // 국기
                Ellipse()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.green)
                    .offset(x: 2, y: 2) // 살짝 여백을 줘서 겹치게
            }
        }
    }
}

struct LocationPagerSheet: View {
    let locations: [Location]
    @Binding var selectedIndex: Int
    
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: -50) {
                    
                    Spacer(minLength: UIScreen.main.bounds.width / 2 - 75) // 카드 절반만큼 왼쪽 패딩
                    
                    ForEach(locations.indices, id: \.self) { index in
                        LocationCard(location: locations[index], isSelected: selectedIndex == index)
                            .scaleEffect(selectedIndex == index ? 1.0 : 0.95)
                            .zIndex(selectedIndex == index ? 999 : Double(-abs(index - selectedIndex))) // ✅ 수정
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                    }
                    Spacer(minLength: UIScreen.main.bounds.width / 2 - 75) // 카드 절반만큼 오른쪽 패딩
                }
        }
        .offset(y: 500)
    }
}

struct LocationCard: View {
    let location: Location
    var isSelected: Bool // 선택 여부 외부에서 전달

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(location.name)
                .resizable()
                .scaledToFill()
                .frame(width: isSelected ? 140 : 100, height: isSelected ? 140 : 100)
                .cornerRadius(16)
                .shadow(
                    color: .black.opacity(0.2),
                    radius: isSelected ? 10 : 4,
                    x: 0,
                    y: 4
                )
        }
        .padding(isSelected ? 10 : 0) // ✅ 선택 시 그림자 여백 확보
        .contentShape(Rectangle())     // ✅ 터치 영역 유지
    }
}

struct BottomSheetView: View {
    let location: Location
    let images = ["애플스토어", "경복궁", "테일러스위프트"]
    
    @Binding var detent: PresentationDetent
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(location.name)")
                .font(.system(size: 30, weight: .bold))
            
            Text("Cathedral in Myeongdong, Jung-gu, Seoul, South Korea")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
            
            HStack(spacing: 3) {
                Text("Currently Open")
                    .foregroundColor(.green)
                CustomDot()
                Text("6:30 am - 7 pm")
                CustomDot()
                Text("120 m away")
            }
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.black)
            
            Divider()
                .background(Color.black)
            
            
            Text("Introduction")
                .font(.system(size: 15, weight: .bold))
            
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                CustomDot()
                    .offset(y: -4)
                    .alignmentGuide(.firstTextBaseline) { d in d[.bottom]}
                
                Text("Visited by many tourists for its beautiful Gothic architecture and stained glass windows")
                    .font(.system(size: 12, weight: .regular))
                    .fixedSize(horizontal: false, vertical: true) // 줄바꿈 허용
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                CustomDot()
                    .offset(y: -4)
                    .alignmentGuide(.firstTextBaseline) { d in d[.bottom]}
                Text("Offers a peaceful atmosphere where visitors can experience Korea's religion, history, and culture")
                    .font(.system(size: 12, weight: .regular))
                    .fixedSize(horizontal: false, vertical: true) // 줄바꿈 허용
            }
            
            //            Divider()
            //                .background(Color.black)
            //
            //            ScrollView(.horizontal, showsIndicators: false) {
            //                HStack(spacing: 4) {
            //                    ForEach(images, id: \.self) { imageName in
            //                        Button {
            //                            print("\(imageName) tapped")
            //                            // 원하는 동작을 여기서 실행
            //                        } label: {
            //                            VStack {
            //                                Image(imageName)
            //                                    .resizable()
            //                                    .scaledToFill()
            //                                    .frame(width:124, height: 176)
            //                                    .clipped()
            //                                    .cornerRadius(16)
            //                                    .shadow(radius: 4)
            //
            //                            }
            //                        }
            //                        .buttonStyle(PlainButtonStyle()) // 버튼 효과 제거
            //                    }
            //                }
            //            }
            
            //            if detent == .large {
            Divider()
                .background(Color.black)
            
            Text("Visitors Today")
                .font(.system(size: 15, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(images, id: \.self) { imageName in
                        Button {
                            print("\(imageName) tapped")
                            // 원하는 동작을 여기서 실행
                        } label: {
                            VStack {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:30, height: 30)
                                    .clipped()
                                    .cornerRadius(16)
                                    .shadow(radius: 4)
                                
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // 버튼 효과 제거
                    }
                }
            }
            
            //            }
        }
        .foregroundColor(.black)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // ⬅️ 명시적 왼쪽 정렬
        
        //        if detent != .large {
        //            Button {
        //                detent = .large
        //            } label: {
        //                Text("View More")
        //                    .font(.custom("SettlementLabel", size: 12))
        //                    .frame(width: 80, height: 28.75) // 버튼 크기 고정
        //                    .background(Color.black)
        //                    .foregroundColor(.white)
        //                    .clipShape(Capsule())
        //            }
        //        }
        
        Spacer()
    }
    
}

struct CustomDot: View {
    var body: some View {
        Circle()
            .frame(width: 3, height: 3)
            .foregroundColor(.black)
            .offset(y: 2) // 세로 위치 조정
    }
}

struct CustomSearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search for places", text: $text, onCommit: onCommit)
                .foregroundColor(.primary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 4) // ✅ 아래쪽 그림자
        )
        .padding(.horizontal)
    }
}

struct SpeechBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 12
        let tailWidth: CGFloat = 14
        let tailHeight: CGFloat = 8
        
        let bubbleHeight = rect.height - tailHeight
        
        // 말풍선 본체
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: bubbleHeight), cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // 꼬리 (아래 중앙)
        let tailStartX = rect.midX - tailWidth / 2
        path.move(to: CGPoint(x: tailStartX, y: bubbleHeight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        path.addLine(to: CGPoint(x: tailStartX + tailWidth, y: bubbleHeight))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    MapView()
}
