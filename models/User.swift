

import Foundation
import FirebaseFirestoreSwift

struct Users: Identifiable, Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var email: String
    var contactNo: String
    var paymentInfo: String? = ""

    init(id: String? = nil, name: String = "", email: String = "", contactNo: String = "", paymentInfo: String? = "") {
        self.name = name
        self.email = email
        self.contactNo = contactNo
        self.paymentInfo = paymentInfo
    }
}
