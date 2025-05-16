//
//  MapView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 09/05/25.
//

import Foundation
import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationStack {
            Text("Map View")
        }
//        .background(Color.primer)
        .navigationTitle(Text("Map"))
    }
}

#Preview {
    MapView()
}
