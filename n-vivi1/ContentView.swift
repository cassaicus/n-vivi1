//
//  ContentView.swift
//  n-vivi1
//
//  Created by ibis on 2025/10/06.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var isPickerPresented = false

    var body: some View {
        NavigationView {
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Text("No Image Selected")
                        .font(.headline)
                }

                Spacer()
            }
            .navigationTitle("iCloud Image Viewer")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Select Image") {
                        isPickerPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

#Preview {
    ContentView()
}
