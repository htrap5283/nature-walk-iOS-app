
import SwiftUI

struct SessionDetailsView: View {
    
    var session: Session
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @State private var showSignInView : Bool = false
    @State private var showPurchaseSessionView: Bool = false
    @State private var isShowingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TabView {
                    ForEach(session.photoURLs, id: \.self) { p in
                        if let url = URL(string: p) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                            }//AsyncImage
                        }
                    }//ForEach
                }//TabView
                .frame(height: 200)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Text(session.name)
                    .font(.largeTitle)
                    .padding(.top, 10)
                
                Text(session.description)
                    .padding(.top, 5)
                
                HStack {
                    Text("Rating: \(session.starRating)/5")
                        .foregroundColor(.orange)
                    Spacer()
                    Text("Price: $\(session.pricePerPerson, specifier: "%.2f") / person")
                        .foregroundColor(.green)
                }//HStack
                .padding(.top, 5)
                
                HStack {
                    Text("Guide: \(session.guideName)")
                    Spacer()
                    Button(action: {
                        if let url = URL(string: "tel://\(session.phoneNumber)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image(systemName: "phone.fill")
                        Text("\(session.phoneNumber)")
                    }//Button
                }//HStack
                .padding(.top, 5)
                
                //Show on Map
                Button(action: {
                    let address = session.address.replacingOccurrences(of: " ", with: "+")
                    let urlString = "https://maps.apple.com/?address=\(address)"
                    if let url = URL(string: urlString) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "map")
                        Text(session.address).padding()
                    }
                }
                
                HStack (alignment: .center){
                    //Favourite Button
                    Button(action: {
                        if(self.fireAuthHelper.user != nil) {
                            self.fireDBHelper.toggleFavourite(session: session)
                        } else {
                            showSignInView = true
                        }
                    }) {
                        if self.fireDBHelper.isFavourite(session: session) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Remove from Favourites")
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: "heart")
                            Text("Add to Favourites")
                                .foregroundColor(.blue)
                        }
                    }//Button
                    
                    Spacer()
                    
                    //Share Button
                    Button(action: {
                        isShowingShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }//Button
                    
                    Spacer()
                    
                    //Purchase Button
                    Button(action: {
                        if(self.fireAuthHelper.user != nil) {
                            self.showPurchaseSessionView = true
                        } else {
                            self.showSignInView = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "cart")
                            Text("Purchase")
                        }
                    }
                }//HStack
                .padding(.top, 10)
                .sheet(isPresented: $isShowingShareSheet) {
                    ShareSheet(activityItems: ["Check out this session: \(session.name) for $\(session.pricePerPerson) per person!"])
                }//sheet
                .sheet(isPresented: $showPurchaseSessionView) {
                    PurchaseSessionView(session: session)
                        .environmentObject(fireAuthHelper)
                        .environmentObject(fireDBHelper)
                }//sheet
                .padding()
                //                Spacer()
            }//VStack
            .padding()
        }//ScrollView
        .onAppear() {
            self.fireAuthHelper.listenToAuthState()
        }
        .navigationTitle(session.name)
        .sheet(isPresented: self.$showSignInView) {
            SignInView()
                .environmentObject(self.fireAuthHelper)
                .environmentObject(self.fireDBHelper)
        }
    }//body
}//SessionDetailView

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

