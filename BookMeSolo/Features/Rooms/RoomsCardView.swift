//
//  RoomsCardView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 13/05/25.
//

import Foundation
import SwiftUI

struct RoomsCardView: View {
    var room: CollabRoomModel
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text("\(room.name)")
                    .font(.system(size: 26, weight: .bold))
                    .padding(.bottom)
                Text("Capacity: \(room.capacity)")
                    .font(.system(size: 18))
                Text("Facilities: Big Desk, TV")
                    .font(.system(size: 18))
            }
            .foregroundColor(.text)
            Spacer()
            Image("\(room.imagePreviews[0])")
                .resizable()
                .frame(width: 90, height: 90)
                .clipShape(.rect(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
        }
        .padding(.all)
        .background(Color.shadow)
    }
}
