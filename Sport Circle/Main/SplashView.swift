//
//  SplashView.swift
//  Sport Circle
//
//  Created by kinderBono on 24/10/2023.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.blues.ignoresSafeArea()
            Image("logo1")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
        }
    }
}

#Preview {
    SplashView()
}
