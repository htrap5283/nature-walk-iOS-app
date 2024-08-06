
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    var body: some View {
        TabView {
            SessionListView()
                .environmentObject(self.fireAuthHelper)
                .environmentObject(self.fireDBHelper)
                .tabItem {
                    Label("Sessions", systemImage: "list.bullet")
                }
            
            FavouritesListView()
                .environmentObject(self.fireAuthHelper)
                .environmentObject(self.fireDBHelper)
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
            
            PurchaseListView()
                .environmentObject(self.fireAuthHelper)
                .environmentObject(self.fireDBHelper)
                .tabItem {
                    Label("Purchase", systemImage: "cart")
                }
            
            ProfileView()
                .environmentObject(self.fireAuthHelper)
                .environmentObject(self.fireDBHelper)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .onAppear() {
            self.fireAuthHelper.listenToAuthState()
        }
    }
}
