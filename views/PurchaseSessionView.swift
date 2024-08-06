
import SwiftUI

struct PurchaseSessionView: View {
    var session: Session
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    private let tax = 0.13
    
    //State data of input
    @State private var noOfTickets: Int = 1
    @State private var subTotal: Double = 0.0
    @State private var taxAmount: Double = 0.0
    @State private var totalAmount: Double = 0.0
    
    @State private var showAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Purchase Session")
                .font(.system(size: 24))
                .padding(.top, 10)
            
            Stepper(value: self.$noOfTickets, in: 1...20, step: 1){
                Text("Number of Tickets: \(self.noOfTickets)")
                    .fontWeight(.bold)
            }.onChange(of: self.noOfTickets) {
                self.subTotal = Double(self.noOfTickets) * self.session.pricePerPerson
                self.taxAmount = Double(self.subTotal) * self.tax
                self.totalAmount = Double(self.subTotal) + self.taxAmount
            }
            
            HStack {
                Text("Sub Total")
                    .fontWeight(.bold)
                Spacer()
                Text("$\(subTotal, specifier: "%.2f")")
            }
            
            HStack {
                Text("Tax")
                    .fontWeight(.bold)
                Spacer()
                Text("$\(taxAmount, specifier: "%.2f")")
            }
            
            HStack {
                Text("Total Amount")
                    .fontWeight(.bold)
                Spacer()
                Text("$\(totalAmount, specifier: "%.2f")")
            }
            
            Button(action: {
                performPurchase()
            }) {
                Text("Purchase")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 5)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
        }
        .onAppear() {
            self.subTotal = Double(self.noOfTickets) * self.session.pricePerPerson
            self.taxAmount = Double(self.subTotal) * self.tax
            self.totalAmount = Double(self.subTotal) + self.taxAmount
        }
        .alert(isPresented: self.$showAlert) {
            Alert(title: Text("Purchase Complete"), message: Text("You have successfully purchased the ticket"), dismissButton: .default(Text("OK"), action: {
                dismiss()
            }))
        }
        .navigationTitle(session.name)
        .padding()
    }
    
    func performPurchase() {
        let purchase = PurchaseSession(name: self.session.name, description: self.session.description, starRating: self.session.starRating, guideName: self.session.guideName, phoneNumber: self.session.phoneNumber, photoURLs: self.session.photoURLs, pricePerPerson: self.session.pricePerPerson, dateTime: self.session.dateTime, address: self.session.address, numberOfTickets: self.noOfTickets, totalAmount: self.totalAmount)
        
        self.fireDBHelper.purchaseSession(session: purchase)
        self.showAlert = true
    }
}

