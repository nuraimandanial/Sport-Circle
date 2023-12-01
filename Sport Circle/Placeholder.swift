////
//  Placeholder.swift
//  Sport Circle
//
//  Created by kinderBono on 31/10/2023.
//

import SwiftUI

struct Placeholder: View {
    var type: String = ""
    var width: CGFloat = 80
    var height: CGFloat = 120
    
    var body: some View {
        if type == "Empty Image" {
            emptyImage
        } else if type == "Empty Profile" {
            emptyProfile
        } else {
            EmptyView()
        }
    }
    
    var emptyImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.grays.opacity(0.3))
                .frame(height: height)
            Image("logo2")
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
    
    var emptyProfile: some View {
        Circle()
            .frame(width: width)
            .overlay {
                Image("logo1")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding()
            }
    }
}

#Preview {
    Placeholder()
}
