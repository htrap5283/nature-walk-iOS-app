
import SwiftUI

struct FavouritesListView: View {
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                if let user = fireAuthHelper.user {
                    List {
                        ForEach(fireDBHelper.favouritesList) { favourite in
                            HStack {
                                if let url = URL(string: favourite.photoURLs[0]) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(12)
                                            .clipped()
                                    } placeholder: {
                                        ProgressView()
                                    }//AsyncImage
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(favourite.name)
                                        .font(.headline)
                                    Text("$\(favourite.pricePerPerson, specifier: "%.2f") per person")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let favourite = fireDBHelper.favouritesList[index]
                                fireDBHelper.removeFavourite(session: favourite)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("Favourites")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {
                                fireDBHelper.removeAllFavourite()
                            }) {
                                Label("Remove All", systemImage: "trash")
                            }
                        }
                    }
                } else {
                    Text("Please log in to view your favourites.")
                        .padding()
                    
                    Button(action: {
                        showSignInView = true
                    }) {
                        Text("Log In")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $showSignInView) {
                        SignInView()
                            .environmentObject(fireAuthHelper)
                            .environmentObject(fireDBHelper)
                    }
                }
            }
        }
        
        .onAppear {
//            if let user = fireAuthHelper.user {
//                fireDBHelper.getAllFavourites(forUser: user.uid)
//            }
        }
    }
}
