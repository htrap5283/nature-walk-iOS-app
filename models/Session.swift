
import Foundation
import FirebaseFirestoreSwift

struct Session: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var starRating: Int
    var guideName: String
    var phoneNumber: String
    var photoURLs: [String] = []
    var pricePerPerson: Double
    var dateTime: Date
    var address: String
    
    init(id: String? = nil, name: String, description: String, starRating: Int, guideName: String, phoneNumber: String, photoURLs: [String], pricePerPerson: Double, dateTime: Date, address: String) {
        self.name = name
        self.description = description
        self.starRating = starRating
        self.guideName = guideName
        self.phoneNumber = phoneNumber
        self.photoURLs = photoURLs
        self.pricePerPerson = pricePerPerson
        self.dateTime = dateTime
        self.address = address
    }
}
