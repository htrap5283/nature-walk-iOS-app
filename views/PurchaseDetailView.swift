

import SwiftUI

struct PurchaseDetailView: View {
    
    var purchase: PurchaseSession
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text(purchase.name)
                    .font(.largeTitle)
                    .padding(.top, 10)
                
                Text(purchase.description)
                    .padding(.top, 5)
                
                HStack {
                    Text("Rating: \(purchase.starRating)/5")
                        .foregroundColor(.orange)
                    Spacer()
                    Text("Price: $\(purchase.pricePerPerson, specifier: "%.2f") / person")
                        .foregroundColor(.green)
                }//HStack
                .padding(.top, 5)
                
                HStack {
                    Text("Guide: \(purchase.guideName)")
                    Spacer()
                    Button(action: {
                        if let url = URL(string: "tel://\(purchase.phoneNumber)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(systemName: "phone.fill")
                        Text("\(purchase.phoneNumber)")
                    }//Button
                }//HStack
                .padding(.top, 5)
                
                //Show on Map
                Button(action: {
                    let address = purchase.address.replacingOccurrences(of: " ", with: "+")
                    let urlString = "https://maps.apple.com/?address=\(address)"
                    if let url = URL(string: urlString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "map")
                        Text(purchase.address).padding()
                    }
                }
                .padding(.top, 10)
                
                HStack {
                    Text("No. of Tickets:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(purchase.numberOfTickets)")
                }
                
                HStack {
                    Text("Total Amount")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(purchase.totalAmount, specifier: "%.2f")")
                }
            }//VStack
            .padding()
        }//ScrollView
    }//body
}//PurchaseDetailView
