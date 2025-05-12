//
//  DashboardCardView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 12/05/25.
//

import Foundation
import SwiftUI

struct DashboardCardView: View {
    let date: Date
    let selectedTab: DashboardTab
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading){
                    Text("Collab Room 1")
                        .font(.system(size: 26, weight: .bold))
                        .padding(.bottom)
                    Text("08:00 - 09:55")
                        .font(.system(size: 22))
                    Text("Capacity: 6")
                        .font(.system(size: 18))
                    Text("Facilities: Big Desk, TV")
                        .font(.system(size: 18))
                }
                .foregroundColor(.text)
                Spacer()
                Image("Collab Room 1")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            }
            .padding(.bottom)
            
            Button(action: {}) {
                Text("Book")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .tint(.primer)
                    .background(.button)
                    .cornerRadius(10)
            }
        }
        .padding(.all)
        .frame(
            maxWidth: .infinity,
            maxHeight: 250
        )
        .background(.shadow)
    }
}
