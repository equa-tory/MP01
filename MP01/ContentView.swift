//
//  ContentView.swift
//  MP01
//
//  Created by Alex Barauskas on 25.01.2025.
//

import SwiftUI

struct ContentView: View {
    @Namespace private var animationNamespace
    @State private var selectedPlaylistItem: PlaylistData? = nil
    @State private var selPl: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State var scrollPos = ScrollPosition()
    @State var isPlaying: Bool = false
    
    let list = (1..<(4*15)).map { PlaylistData(name: "\($0)") }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                scrollableGrid
                if let selectedItem = selectedPlaylistItem {
                    expandedDetailView(for: selectedItem)
                }
                ControlPanel(selPl: $selPl)
            }
            .navigationTitle("MusicPlayer")
            .toolbar {
                Button("Add", systemImage: "plus") {
                    scrollPos.scrollTo(edge: .top)
                }
            }
            .tint(colorScheme == .dark ? .white : .black)
        }
    }
    
    var scrollableGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: -32), count: 2)
        
        return ScrollView {
            LazyVGrid(columns: columns, spacing: 16, pinnedViews: .sectionHeaders) {
                Section(header: headerView(title: "Fav")) {
                    playlistItems
                }
            }
            .padding(.horizontal)
        }
    }
    
    var playlistItems: some View {
        ForEach(list, id: \.id) { item in
            PlaylistItem(
                name: item.name,
                namespace: animationNamespace,
                isSelected: selectedPlaylistItem?.id == item.id
            )
            .onTapGesture {
                withAnimation(.spring()) {
                    selectedPlaylistItem = item
                    selPl = true
                }
            }
        }
    }
    
    func headerView(title: String) -> some View {
        Text(title)
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func expandedDetailView(for item: PlaylistData) -> some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedPlaylistItem = nil
                        selPl = false
                    }
                }
            
            PlaylistDetailView(
                name: item.name,
                namespace: animationNamespace
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
            .cornerRadius(50)
            .shadow(radius: 10)
            .padding()
        }
    }
}

struct PlaylistItem: View {
    let name: String
    let namespace: Namespace.ID
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.gray)
                .matchedGeometryEffect(id: name, in: namespace)
                .frame(height: .infinity)
            
            Text("Details for \(name)")
                .font(.title)
                .matchedGeometryEffect(id: "\(name) det", in: namespace)
                .padding()
                .frame(maxWidth: .infinity)
                .opacity(0)
            
            Text("\(name.first ?? " ")")
                .font(.system(size: 75).bold())
                .foregroundColor(Color.white)
                .matchedGeometryEffect(id: "\(name) text", in: namespace)
                .opacity(1)
        }
        .frame(width: 150, height: 150)
    }
}

struct PlaylistDetailView: View {
    let name: String
    let namespace: Namespace.ID
    
    var body: some View {
        VStack {
            ZStack{
                
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.gray)
                    .matchedGeometryEffect(id: name, in: namespace)
                    .frame(height: .infinity)
                
                Text("Details for \(name)")
                    .font(.title)
                    .matchedGeometryEffect(id: "\(name) det", in: namespace)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .opacity(1)
                
                Text("\(name.first ?? " ")")
                    .font(.system(size: 75).bold())
                    .foregroundColor(Color.white)
                    .matchedGeometryEffect(id: "\(name) text", in: namespace)
                    .opacity(0)
            }
        }
    }
}

struct PlaylistData: Hashable {
    let id = UUID()
    var name: String = "Untitled"
}

struct ControlPanel: View {
    @Binding var selPl: Bool
    @State private var isShowing: Bool = true
    @State private var isPlaying: Bool = false
    @Namespace private var anim
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: isShowing ? .infinity : 100, height: 100)
                .foregroundColor(Color.gray)
                .shadow(radius: selPl ? 0 : 8, x: selPl ? 0 : 16, y: selPl ? 0 : 16)
                .padding(.horizontal)
                .animation(.smooth(duration: 0.3))
            
            HStack {
                if isShowing {
                    Spacer()
                    
                    Button {
                        print("back")
                    } label: {
                        Image(systemName: "backward.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 40, maxHeight: 40)
                    }
    
                    Spacer()
                }
                
                Button {
                    print("play")
                    isPlaying.toggle()
                    isShowing.toggle()
                } label: {
                    Image(systemName: (isPlaying && !isShowing) ? "play.fill" : "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 30, maxHeight: 30)
                }
                
                if isShowing {
                    Spacer()
                    
                    Button {
                        print("forward")
                    } label: {
                        Image(systemName: "forward.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 40, maxHeight: 40)
                    }
                    
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: isShowing ? .infinity : 100, maxHeight: 100)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
