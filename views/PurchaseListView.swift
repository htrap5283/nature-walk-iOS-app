
import SwiftUI

struct PurchaseListView: View {
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                if let user = self.fireAuthHelper.user {
                    List(self.fireDBHelper.purchaseList){ purchase in
                        NavigationLink(destination: PurchaseDetailView(purchase: purchase)
                            .environmentObject(fireDBHelper)
                            .environmentObject(fireAuthHelper)){
                                
                                HStack {
                                    if let url = URL(string: purchase.photoURLs[0]) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(12)
                                                .clipped()
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 60, height: 60)
                                        }//AsyncImage
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(purchase.name)
                                            .font(.headline)
                                        Text("\(purchase.dateTime.formatted())")
                                            .font(.subheadline)
                                    }//VStack
                                }//HStack
                            }//NavigationLink
                    }//List
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("Purchases")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text("Please log in to view your purchases.")
                        .padding()
                    
                    Button(action: {
                        showSignInView = true
                    }) {
                        Text("Log In")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }//Button
                    .sheet(isPresented: $showSignInView) {
                        SignInView()
                            .environmentObject(fireAuthHelper)
                            .environmentObject(fireDBHelper)
                    }
                }//if-else
            }//VStack
        }//NavigationView
    }//body
}//PurchaseListView
