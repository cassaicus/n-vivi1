//
//  ContentView.swift
//  n-vivi1
//
//  Created by ibis on 2025/10/06.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImages: [UIImage] = []
    @State private var isPickerPresented = false

    var body: some View {
        NavigationView {
            VStack {
                if !selectedImages.isEmpty {
                    TabView {
                        ForEach(selectedImages, id: \.self) { img in
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                } else {
                    Text("No Images Selected")
                        .font(.headline)
                }
            }
            .navigationTitle("Image Gallery")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Select Images") {
                        isPickerPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(selectedImages: $selectedImages)
            }
        }
    }
}

#Preview {
    ContentView()
}
