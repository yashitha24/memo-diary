//
//  PhotoGalleryView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

/*
 This file defines two views: PhotoGalleryView and PhotoViewer. PhotoGalleryView displays a
 grid of images from the CalendarViewModel's data. Users can tap on images to view them in
 fullscreen viewer provided by the PhotoViewer view.
 */

import Foundation
import SwiftUI

// View for displaying a photo gallery.
struct PhotoGalleryView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State private var isShowingPhotoViewer = false
    @State private var selectedImageIndex = 0
    
    var body: some View {
        let images = viewModel.imagesForDates.values.flatMap { $0 }
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .onTapGesture {
                            selectedImageIndex = index
                            isShowingPhotoViewer = true
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Photo Gallery")
        .sheet(isPresented: $isShowingPhotoViewer) {
            PhotoViewer(images: .constant(images), selectedImageIndex: $selectedImageIndex)
        }
    }
}

// View for displaying images in a fullscreen viewer.
struct PhotoViewer: View {
    @Binding var images: [UIImage]
    @Binding var selectedImageIndex: Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(uiImage: images[index])
                    .resizable()
                    .scaledToFit()
                    .tag(index)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}
