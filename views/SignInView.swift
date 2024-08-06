
import SwiftUI

struct SignInView: View {
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    //State data of input
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    
    //flag to navigate to session list
    @State private var showSessionList = false
    
    //flag to shwo alert
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                //Logo Image
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .clipped()
                    .padding(.vertical, 60)
                
                //Email
                VStack(spacing: 20) {
                    HStack {
                        Text("Email: ")
                            .font(.system(size: 18))
                            .frame(width: 90, alignment: .trailing)
                        
                        TextField("Enter Email...", text: self.$email)
                            .padding(.horizontal,10)
                            .padding(.vertical, 10)
                            .font(.system(size: 18))
                            .keyboardType(.default)
                            .textInputAutocapitalization(.never)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2))
                    }//HStack
                    
                    //Password
                    HStack {
                        Text("Password: ")
                            .font(.system(size: 18))
                            .frame(width: 90, alignment: .trailing)
                        
                        SecureField("Enter Password...", text: self.$password)
                            .padding(.horizontal,10)
                            .padding(.vertical, 10)
                            .font(.system(size: 18))
                            .keyboardType(.default)
                            .textInputAutocapitalization(.never)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2))
                    }//HStack
                    
                    Toggle("Remember Me", isOn: $rememberMe)
                        .toggleStyle(SwitchToggleStyle(tint: Color.green))
                    //Login Button
                    Button {
                        performLogin()
                    } label: {
                        Text("Login")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .fontWeight(.bold)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }//Button
                    .alert(isPresented: self.$showAlert){
                        Alert(title: Text("Error"), message: Text("Invalid credentials.\nPlease enter valid email or password...!!!"))
                    }//alert
                    .buttonStyle(.borderedProminent)
                }//VStack
                .padding(.horizontal, 20)
            }//VStack
            .onAppear() {
                //check
                self.email = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
                self.password = UserDefaults.standard.string(forKey: "KEY_PASSWORD") ?? ""
            }//onAppear
            .padding()
        }//NavigationStack
        
    }//body
    
    // func
    func performLogin() {
        //validate the data
        if (!self.email.isEmpty && !self.password.isEmpty){
            
            //validate credentials
            self.fireAuthHelper.signIn(email: self.email, password: self.password) { state in
                if(state) {
                    dismiss()
                } else {
                    print(#function, "Invalid credentials")
                }
            }
        }else{
            //trigger alert displaying errors
            print(#function, "email and password cannot be empty")
        }
    }
}

