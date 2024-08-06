
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var contactNo: String = ""
    @State private var paymentInfo: String = ""
    
    @State private var alertTitle: String = ""
    @State private var alertMsg: String = ""
    @State private var showAlert: Bool = false
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        VStack {
            if let user = fireAuthHelper.user {
                Text("Profile")
                    .font(.system(size: 24))
                    .padding(.top, 10)
                
                //Email
                HStack {
                    Text("Email: ")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(width: 120, alignment: .trailing)
                    
                    TextField("Enter Email...", text: self.$email)
                        .padding(.horizontal,10)
                        .padding(.vertical, 10)
                        .font(.system(size: 18))
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2))
                        .disabled(true)
                }//HStack
                
                //Name
                HStack {
                    Text("Name: ")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(width: 120, alignment: .trailing)
                    
                    TextField("Enter Name...", text: self.$name)
                        .padding(.horizontal,10)
                        .padding(.vertical, 10)
                        .font(.system(size: 18))
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2))
                }//HStack
                
                //ContactNo
                HStack {
                    Text("Contact No: ")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(width: 120, alignment: .trailing)
                    
                    TextField("Enter ContactNo...", text: self.$contactNo)
                        .padding(.horizontal,10)
                        .padding(.vertical, 10)
                        .font(.system(size: 18))
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2))
                }//HStack
                
                //CarPlateNo
                HStack {
                    Text("Payment Info: ")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .frame(width: 120, alignment: .trailing)
                    
                    SecureField("Enter Card No...", text: self.$paymentInfo)
                        .padding(.horizontal,10)
                        .padding(.vertical, 10)
                        .font(.system(size: 18))
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2))
                }//HStack
                
                //Update Button
                Button {
                    performUpdate()
                } label: {
                    Text("Update")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .fontWeight(.bold)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }//Button
                .buttonStyle(.borderedProminent)
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                
                Spacer()
            } else {
                Text("Please log in to view your profile.")
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
        .padding()
        .onAppear() {
            self.email = fireDBHelper.userProfile.email
            self.name = fireDBHelper.userProfile.name
            self.contactNo = fireDBHelper.userProfile.contactNo
            self.paymentInfo = fireDBHelper.userProfile.paymentInfo ?? ""
        }
        
        .alert(isPresented: self.$showAlert){
            Alert(title: Text(alertTitle), message: Text(alertMsg))
        }//alert
    }//body
    
    func performUpdate() {
        //validate the data
        if (!self.email.isEmpty && !self.name.isEmpty && !self.contactNo.isEmpty){
            
            //validate credentials
            self.fireDBHelper.updateUserProfile(user: Users(name: self.name, email: self.email, contactNo: self.contactNo, paymentInfo: self.paymentInfo)) { state, msg  in
                if(state) {
                    self.alertTitle = "Success"
                    self.alertMsg = msg
                    self.showAlert = true
                    print(#function, msg)
                } else {
                    self.alertTitle = "Error"
                    self.alertMsg = msg
                    self.showAlert = true
                    print(#function, msg)
                }
            }
        }else{
            //trigger alert displaying errors
            self.alertTitle = "Error"
            self.alertMsg = "Please enter all details. Fields cannot be empty...!!!"
            self.showAlert = true
            print(#function, "email and password cannot be empty")
        }
    }
}//ProfileView
