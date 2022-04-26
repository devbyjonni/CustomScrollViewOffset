//
//  ContentView.swift
//  CustomScrollViewOffset
//
//  Created by Jonni Akesson on 2022-04-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var offset: CGPoint = .zero
    
    var body: some View {
        NavigationView {
            CustomScrollView(offset: $offset, showIndicator: true, axis: .vertical, content: { //.horizontal for H
                LazyVStack(spacing: 15) { // HStack for H
                    
                    ForEach(1...30, id: \.self) { _ in
                        HStack(spacing: 15) {
                            Circle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: 70, height: 70)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(height: 15)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(height: 15)
                                    .padding(.trailing, 90)
                                    //.padding(.trailing, 90) for H
                            }
                            //.frame(width: 70) for H
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            })
            .navigationTitle("Offset: \(String(format: "%.1f", offset.y))") // offset.x for H
        }
    }
}

struct CustomScrollView<Content: View>: View {
    
    var content: Content
    
    @Binding var offset: CGPoint
    
    var showIndicator: Bool
    var axis: Axis.Set
    
    init(offset: Binding<CGPoint>, showIndicator: Bool, axis: Axis.Set, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._offset = offset
        self.showIndicator = showIndicator
        self.axis = axis
    }
    
    @State var startOffset: CGPoint = .zero
    var body: some View {
        ScrollView(.vertical, showsIndicators: true, content: {
            content
            
                .overlay(
                    
                    GeometryReader { proxy -> Color in
                        let rect = proxy.frame(in: .global)
                        
                        if startOffset == .zero {
                            DispatchQueue.main.async {
                                startOffset = CGPoint(x: rect.minX, y: rect.minY)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.offset = CGPoint(x: startOffset.x - rect.minX, y: startOffset.y - rect.minY)
                        }
                        
                        return Color.clear
                    }
                        .frame(width: UIScreen.main.bounds.width, height: 0)
                    
                    , alignment: .top
                )
        })
    }
}
