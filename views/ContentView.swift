
import SwiftUI

struct ContentView: View {
    
    var fireDBHelper: FireDBHelper = FireDBHelper.getInstance()
    var fireAuthHelper: FireAuthHelper = FireAuthHelper.getInstance()
    
    var body: some View {
        MainTabView()
                   .environmentObject(self.fireAuthHelper)
                   .environmentObject(self.fireDBHelper)
        
//        VStack {
//            SessionListView()
//                .environmentObject(self.fireAuthHelper)
//                .environmentObject(self.fireDBHelper)
//        }
//        .padding()
    }
}

