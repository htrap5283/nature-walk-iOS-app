

import SwiftUI

struct SessionListView: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @State private var showSignInView : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                //Session List
                List(self.fireDBHelper.sessionList) { session in
                    NavigationLink(destination: SessionDetailsView(session: session)
                        .environmentObject(fireDBHelper)
                        .environmentObject(fireAuthHelper)) {
                        HStack {
                            //Session Image
                            if let url = URL(string: session.photoURLs[0]) {
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
                            
                            VStack(alignment: .leading) {
                                //Session name and price
                                Text(session.name)
                                    .font(.headline)
                                Text("$\(session.pricePerPerson, specifier: "%.2f") per person")
                                    .font(.subheadline)
                            }//VStack
                            Spacer()
                        }//HStack
                    }//NavigationLink
                }//List
                .listStyle(InsetGroupedListStyle())
            }//VStack
            .navigationTitle("Nature Walk Sessions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //Login or Logout
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //dismiss()
                        if(self.fireAuthHelper.user != nil) {
                            self.fireAuthHelper.signOut()
                        } else {
                            self.showSignInView = true
                        }
                    }){
                        if(self.fireAuthHelper.user != nil) {
                            HStack {
                                Image(systemName: "power.circle")
                                Text("SignOut")
                            }
                        } else {
                            HStack {
                                Image(systemName: "power.circle")
                                Text("SignIn")
                            }
                        }
                    }
                    
                }//ToolbarItem
                
                //EXTRA FOR TESTING ONLY//
    //            ToolbarItem(placement: .navigationBarTrailing) {
    //                Button{
    //                    showSignInView = true
    //                } label: {
    //                    Label("Logout", systemImage: "power.circle")
    //                }
    //
    //            }//ToolbarItem
            }//toolbar
        }//NavigationView
        .navigationBarBackButtonHidden()
        
        .sheet(isPresented: self.$showSignInView) {
            SignInView()
                .environmentObject(self.fireAuthHelper)
                .environmentObject(self.fireDBHelper)
        }
    }
}

