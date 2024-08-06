import Foundation
import FirebaseAuth

class FireAuthHelper: ObservableObject {
    @Published var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    private static var shared: FireAuthHelper?
    
    static func getInstance() -> FireAuthHelper {
        if(shared == nil) {
            shared = FireAuthHelper()
        }
        
        return shared!
    }
    
    func listenToAuthState(){
        Auth.auth().addStateDidChangeListener{[weak self] _, user in
            guard let self = self else {
                //no change in the auth state if the reference to the self object is the same
                //no action to perform
                //self.user = user
                return
            }
            self.user = user
        }
    }
    
    func signIn(email : String, password : String, completion: @escaping (Bool) -> Void){
        var status: Bool = false
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
            
            guard let result = authResult else {
                print(#function, "Error while signing in : \(error)")
                completion(false)
                return
            }
            
            print(#function, "authResult : \(authResult)")
            
            switch authResult {
            case .none:
                print(#function, "Unable to sign in : \(authResult?.description)")
                completion(false)
                break
            case.some(_):
                print(#function, "Successfully signed in user : \(authResult?.description)")
                
                self.user = authResult?.user
                UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
                FireDBHelper.getInstance().getAllFavourites()
                FireDBHelper.getInstance().getAllPurchases()
                FireDBHelper.getInstance().getUserProfile()
                completion(true)
                break
                
            }
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            FireDBHelper.getInstance().favouritesList.removeAll()
            FireDBHelper.getInstance().purchaseList.removeAll()
            FireDBHelper.getInstance().userProfile = Users()
        } catch let error {
            print(#function, "Unable to sign out user : \(error)")
        }
    }
    
}
