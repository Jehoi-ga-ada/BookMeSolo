//
//  HistoryCardView.swift
//  BookMeSolo
//
//  Created by Jehoiada Wong on 13/05/25.
//

import SwiftUI
import Foundation

struct HistoryCardView: View {
    var receipt: BookingReceiptModel
    let onDelete: (BookingReceiptModel) -> Void
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading){
                    Text("\(receipt.collab.name)")
                        .font(.system(size: 26, weight: .bold))
                        .padding(.bottom)
                    Text(receipt.session)
                        .font(.system(size: 22))
                    Text("Capacity: \(receipt.collab.capacity)")
                        .font(.system(size: 18))
                    Text("Facilities: Big Desk, TV")
                        .font(.system(size: 18))
                }
                .foregroundColor(.text)
                Spacer()
                Image("\(receipt.collab.imagePreviews[0])")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            }
            .padding(.bottom)
            
            Button(action: {}) {
                Text("Edit")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .tint(.primer)
                    .background(.button)
                    .cornerRadius(10)
            }
            Button{
                onDelete(receipt)
            } label: {
                Text("Delete")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .tint(.text)
                    .background(.delete)
                    .cornerRadius(10)
            }
        }
        .padding(.all)
        .frame(height: 290)
        .background(.shadow)
    }
}
