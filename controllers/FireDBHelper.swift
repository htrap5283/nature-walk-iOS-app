

import Foundation
import FirebaseFirestore

class FireDBHelper: ObservableObject {
    @Published var userProfile = Users()
    @Published var sessionList = [Session]()
    @Published var favouritesList = [Session]()
    @Published var purchaseList = [PurchaseSession] ()
    
    //singleton instance
    static var shared: FireDBHelper?
    
    //declare the object of Firestore to be used in CRUD operation
    private let db: Firestore
    
    //represent field names to be used in Firestore document JSON object to avoid typing mistake
    private let COLLECTION_NAME: String = "Sessions"
    private let FIELD_NAME: String = "name"
    private let FIELD_DESCRIPTION: String = "description"
    private let FIELD_STAR_RATING: String = "starRating"
    private let FIELD_GUIDE_NAME: String = "guideName"
    private let FIELD_PHONE_NUMBER: String = "phoneNumber"
    private let FIELD_PHOTOS: String = "photos"
    private let FIELD_PRICE_PER_PERSON: String = "pricePerPerson"
    private let FIELD_DATETIME: String = "dateTime"
    private let FIELD_ADDRESS: String = "address"
    private let FIELD_CONTACTNO: String = "contactNo"
    private let FIELD_PAYMENTINFO: String = "paymentInfo"
    
    private let USER_FAVOURITES_COLLECTION = "User"
    private let FAVOURITES_COLLECTION = "Favourites"
    private let PURCHASE_COLLECTION = "Purchases"
    private let PROFILE_COLLECTION = "Profile"
    
    init(db: Firestore) {
        self.db = db
        addHardcodedSessionsIfNeeded()
    }
    
    static func getInstance() -> FireDBHelper {
        if(shared == nil) {
            shared = FireDBHelper(db: Firestore.firestore())
        }
        return shared!
    }
    
    private func addHardcodedSessionsIfNeeded() {
        let sessionsRef = db.collection(COLLECTION_NAME)
        sessionsRef.getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            
            // Check if there are any documents in the collection
            if snapshot.documents.isEmpty {
                // Add hardcoded sessions if the collection is empty
                self?.addHardcodedSessions()
                self?.getAllSession()
            } else {
                self?.getAllSession()
            }
        }
    }
    
    private func addHardcodedSessions() {
        let sessions = [
            Session(name: "Meadow Adventure",
                    description: "Meadow Adventure is an enchanting outdoor experience designed to immerse visitors in the natural beauty and tranquility of lush meadows. This adventure offers a perfect blend of relaxation and exploration, suitable for individuals, families, and groups looking to escape the hustle and bustle of everyday life.",
                    starRating: 3,
                    guideName: "Alice Johnson",
                    phoneNumber: "555-123-4567",
                    photoURLs: ["https://i.postimg.cc/9fycQgsj/session1-1.jpg", "https://i.postimg.cc/mDRBzNG1/session1-2.jpg"],
                    pricePerPerson: 15.0,
                    dateTime: Date(),
                    address: "789 Meadow Lane, Toronto"),
            
            Session(name: "Morning Park Walk",
                    description: "Morning Park Walk is a refreshing and invigorating activity designed to help you start your day on a positive note. Whether you are a nature enthusiast, fitness lover, or simply looking for a peaceful way to begin your day, this walk offers a perfect opportunity to connect with the outdoors, enjoy the fresh air, and appreciate the serene beauty of the park in the early morning hours.",
                    starRating: 4,
                    guideName: "John Doe",
                    phoneNumber: "123-456-7890",
                    photoURLs: ["https://i.postimg.cc/nzkZvjHR/session2-1.jpg", "https://i.postimg.cc/3Nxh98NK/session2-2.jpg"],
                    pricePerPerson: 10.0,
                    dateTime: Date(),
                    address: "123 Park Avenue, Toronto"),
            
            Session(name: "Valley Exploration",
                    description: "Valley Exploration is an exhilarating outdoor adventure designed for those eager to discover the hidden gems of lush valleys. This experience offers a diverse range of activities that highlight the natural beauty, geological wonders, and rich biodiversity of valley landscapes. Perfect for adventurers, nature enthusiasts, and families, Valley Exploration promises an unforgettable journey into the heart of nature.",
                    starRating: 5,
                    guideName: "Jane Smith",
                    phoneNumber: "098-765-4321",
                    photoURLs: ["https://i.postimg.cc/fyqNrGSY/session3-1.jpg", "https://i.postimg.cc/fW8Dy9qk/session3-2.jpg"],
                    pricePerPerson: 20.0,
                    dateTime: Date(),
                    address: "456 Valley Road, Toronto"),
            
            Session(name: "Valley Exploration",
                    description: "Valley Exploration is an exhilarating outdoor adventure designed for those eager to discover the hidden gems of lush valleys. This experience offers a diverse range of activities that highlight the natural beauty, geological wonders, and rich biodiversity of valley landscapes. Perfect for adventurers, nature enthusiasts, and families, Valley Exploration promises an unforgettable journey into the heart of nature.",
                    starRating: 5,
                    guideName: "Jane Smith",
                    phoneNumber: "098-765-4321",
                    photoURLs: ["https://i.postimg.cc/fyqNrGSY/session3-1.jpg", "https://i.postimg.cc/fW8Dy9qk/session3-2.jpg"],
                    pricePerPerson: 20.0,
                    dateTime: Date(),
                    address: "456 Valley Road, Toronto")
        ]
        
        for session in sessions {
            do {
                _ = try db.collection(COLLECTION_NAME).addDocument(from: session)
            } catch {
                print("Error adding session to Firestore: \(error)")
            }
        }
    }
    
    func getAllSession(){
        do {
            self.db.collection(COLLECTION_NAME) //reference to collection
            //create a snapshot listner to listen to query results and get real-time updates
                .addSnapshotListener({(QuerySnapshot, error) in
                    //querySnapshot - query result set
                    
                    //check if result is not nil
                    guard let snapshot = QuerySnapshot else {
                        print(#function, "No results received from firestore : \(error)")
                        return
                    }
                    
                    //snapshot.documentChanges is array of all the documentchanges since last snapshot is retrieved by app
                    snapshot.documentChanges.forEach{(docChange) in
                        //work on each document that changed
                        do {
                            print(#function,"docChange : \(docChange)")
                            print(#function,"docChange.document : \(docChange.document)")
                            print(#function,"docChange.document.data : \(docChange.document.data())")
                            print(#function,"docChange.document.documentID : \(docChange.document.documentID)")
                            
                            var session: Session = try docChange.document.data(as: Session.self)
                            session.id = docChange.document.documentID
                            
                            print(#function,"Session : \(session)")
                            
                            //identify the changes that happened and process the document or object accordingly
                            let matchedIndex = self.sessionList.firstIndex(where: {$0.id == session.id})
                            
                            switch (docChange.type) {
                            case . added:
                                //document change indicates the document was inserted
                                //add the object to booklist
                                print(#function,"Document added : \(docChange.document.documentID) (\(session.name))")
                                
                                if(matchedIndex == nil) {
                                    self.sessionList.append(session)
                                }
                            case .modified:
                                //document change indicates the document was updated
                                print(#function, "Document modified : \(docChange.document.documentID) (\(session.name))")
                                //change/replace the object in booklist
                                if(matchedIndex != nil) {
                                    self.sessionList[matchedIndex!] = session
                                }
                            case.removed:
                                print(#function, "Document deleted : \(docChange.document.documentID) (\(session.name))")
                                //remove the object from booklist
                                if(matchedIndex != nil) {
                                    self.sessionList.remove(at: matchedIndex!)
                                }
                            }
                        } catch let error {
                            print(#function, "Unable to access document change : \(error)")
                        }
                    }
                })
        } catch let error {
            print(#function, "Unable to insert the document to firestore : \(error)")
        }
    }
    
    func getAllFavourites(){
        
        if (FireAuthHelper.getInstance().user == nil) {
            print(#function, "No logged in user")
        } else {
            do {
                let userID = (FireAuthHelper.getInstance().user?.uid)!
                
                self.db.collection(USER_FAVOURITES_COLLECTION) //reference to collection
                //create a snapshot listner to listen to query results and get real-time updates
                    .document(userID)
                    .collection(FAVOURITES_COLLECTION)
                    .addSnapshotListener({(QuerySnapshot, error) in
                        //querySnapshot - query result set
                        
                        //check if result is not nil
                        guard let snapshot = QuerySnapshot else {
                            print(#function, "No results received from firestore : \(error)")
                            return
                        }
                        
                        //snapshot.documentChanges is array of all the documentchanges since last snapshot is retrieved by app
                        snapshot.documentChanges.forEach{(docChange) in
                            //work on each document that changed
                            do {
                                print(#function,"docChange : \(docChange)")
                                print(#function,"docChange.document : \(docChange.document)")
                                print(#function,"docChange.document.data : \(docChange.document.data())")
                                print(#function,"docChange.document.documentID : \(docChange.document.documentID)")
                                
                                var favouriteSession: Session = try docChange.document.data(as: Session.self)
                                favouriteSession.id = docChange.document.documentID
                                
                                print(#function,"Favourite : \(favouriteSession)")
                                
                                //identify the changes that happened and process the document or object accordingly
                                let matchedIndex = self.favouritesList.firstIndex(where: {$0.id == favouriteSession.id})
                                
                                switch (docChange.type) {
                                case . added:
                                    //document change indicates the document was inserted
                                    //add the object to booklist
                                    print(#function,"Document added : \(docChange.document.documentID) (\(favouriteSession.name))")
                                    
                                    if(matchedIndex == nil) {
                                        self.favouritesList.append(favouriteSession)
                                    }
                                case .modified:
                                    //document change indicates the document was updated
                                    print(#function, "Document modified : \(docChange.document.documentID) (\(favouriteSession.name))")
                                    //change/replace the object in booklist
                                    if(matchedIndex != nil) {
                                        self.favouritesList[matchedIndex!] = favouriteSession
                                    }
                                case.removed:
                                    print(#function, "Document deleted : \(docChange.document.documentID) (\(favouriteSession.name))")
                                    //remove the object from booklist
                                    if(matchedIndex != nil) {
                                        self.favouritesList.remove(at: matchedIndex!)
                                    }
                                }
                            } catch let error {
                                print(#function, "Unable to access document change : \(error)")
                            }
                        }
                    })
            } catch let error {
                print(#function, "Unable to insert the document to firestore : \(error)")
            }
        }
    }
    
    
    func toggleFavourite(session: Session) {
        if let index = self.favouritesList.firstIndex(where: { $0.id == session.id }) {
            removeFavourite(session: session)
        } else {
            addFavourite(session: session)
        }
    }
    
    func addFavourite(session: Session){
        guard let userID = FireAuthHelper.getInstance().user?.uid else { return }
        
        if (FireAuthHelper.getInstance().user == nil) {
            print(#function, "No logged in user")
        } else {
            do {
                try self.db.collection(USER_FAVOURITES_COLLECTION)
                    .document(userID) //will create the new document with the given id if it is not exist
                    .collection(FAVOURITES_COLLECTION) //get a reference to subcollection of books
                    .document(session.id!)
                    .setData(from: session)
            } catch let error {
                print(#function,"Unable to insert the document to firestore : \(error)")
            }
        }
    }
    
    func removeFavourite(session : Session){
        do {
            guard let userID = FireAuthHelper.getInstance().user?.uid else { return }
            
            if (FireAuthHelper.getInstance().user == nil) {
                print(#function, "No logged in user")
            }  else {
                self.db.collection(USER_FAVOURITES_COLLECTION)
                    .document(userID)
                    .collection(FAVOURITES_COLLECTION)
                    .document(session.id!)
                    .delete { error in
                        if let err = error {
                            print(#function, "Unable to delete document : \(error)")
                        } else {
                            //self.favouritesList.removeAll()
                            print(#function, "Successfully deleted document : \(session.id)")
                        }
                    }
            }
        } catch let error {
            print(#function, "Unable to delete the document to firestore : \(error)")
        }
    }
    
    func removeAllFavourite(){
        do {
            guard let userID = FireAuthHelper.getInstance().user?.uid else { return }
            
            if (FireAuthHelper.getInstance().user == nil) {
                print(#function, "No logged in user")
            }  else {
                self.db.collection(USER_FAVOURITES_COLLECTION)
                    .document(userID)
                    .collection(FAVOURITES_COLLECTION)
                    .getDocuments{(querySnapshot, error) in
                        if let err = error {
                            print(#function, "Unable to delete subscollection : \(err)")
                        }
                        
                        querySnapshot?.documents.forEach { document in
                            document.reference.delete { error in
                                if let err = error {
                                    print(#function, "Unable to delete document : \(err)")
                                }
                            }
                        }
                    }
                
//                self.db.collection(USER_FAVOURITES_COLLECTION)
//                    .document(userID)
//                    .delete { error in
//                        if let err = error {
//                            print(#function, "Unable to delete document : \(error)")
//                        } else {
//                            self.favouritesList.removeAll()
//                            print(#function, "Successfully deleted document")
//                        }
//                    }
            }
        } catch let error {
            print(#function, "Unable to delete the documents to firestore : \(error)")
        }
    }
    
    func isFavourite(session: Session) -> Bool {
        return self.favouritesList.contains(where: { $0.id == session.id })
    }
    
    func purchaseSession(session: PurchaseSession){
        guard let userID = FireAuthHelper.getInstance().user?.uid else { return }
        
        if (FireAuthHelper.getInstance().user == nil) {
            print(#function, "No logged in user")
        } else {
            do {
                try self.db.collection(USER_FAVOURITES_COLLECTION)
                    .document(userID) //will create the new document with the given id if it is not exist
                    .collection(PURCHASE_COLLECTION) //get a reference to subcollection of books
                    .addDocument(from: session)
            } catch let error {
                print(#function,"Unable to insert the document to firestore : \(error)")
            }
        }
    }
    
    func getAllPurchases(){
        
        if (FireAuthHelper.getInstance().user == nil) {
            print(#function, "No logged in user")
        } else {
            do {
                let userID = (FireAuthHelper.getInstance().user?.uid)!
                
                self.db.collection(USER_FAVOURITES_COLLECTION) //reference to collection
                //create a snapshot listner to listen to query results and get real-time updates
                    .document(userID)
                    .collection(PURCHASE_COLLECTION)
                    .addSnapshotListener({(QuerySnapshot, error) in
                        //querySnapshot - query result set
                        
                        //check if result is not nil
                        guard let snapshot = QuerySnapshot else {
                            print(#function, "No results received from firestore : \(error)")
                            return
                        }
                        
                        //snapshot.documentChanges is array of all the documentchanges since last snapshot is retrieved by app
                        snapshot.documentChanges.forEach{(docChange) in
                            //work on each document that changed
                            do {
                                print(#function,"docChange : \(docChange)")
                                print(#function,"docChange.document : \(docChange.document)")
                                print(#function,"docChange.document.data : \(docChange.document.data())")
                                print(#function,"docChange.document.documentID : \(docChange.document.documentID)")
                                
                                var purchase: PurchaseSession = try docChange.document.data(as: PurchaseSession.self)
                                purchase.id = docChange.document.documentID
                                
                                print(#function,"Purchase : \(purchase)")
                                
                                //identify the changes that happened and process the document or object accordingly
                                let matchedIndex = self.purchaseList.firstIndex(where: {$0.id == purchase.id})
                                
                                switch (docChange.type) {
                                case . added:
                                    //document change indicates the document was inserted
                                    //add the object to booklist
                                    print(#function,"Document added : \(docChange.document.documentID) (\(purchase.name))")
                                    
                                    if(matchedIndex == nil) {
                                        self.purchaseList.append(purchase)
                                    }
                                case .modified:
                                    //document change indicates the document was updated
                                    print(#function, "Document modified : \(docChange.document.documentID) (\(purchase.name))")
                                    //change/replace the object in booklist
                                    if(matchedIndex != nil) {
                                        self.purchaseList[matchedIndex!] = purchase
                                    }
                                case.removed:
                                    print(#function, "Document deleted : \(docChange.document.documentID) (\(purchase.name))")
                                    //remove the object from booklist
                                    if(matchedIndex != nil) {
                                        self.purchaseList.remove(at: matchedIndex!)
                                    }
                                }
                            } catch let error {
                                print(#function, "Unable to access document change : \(error)")
                            }
                        }
                    })
            } catch let error {
                print(#function, "Unable to insert the document to firestore : \(error)")
            }
        }
    }
    
    func getUserProfile(){
        if (FireAuthHelper.getInstance().user == nil) {
            print(#function, "No logged in user")
        } else {
            do {
                let userID = (FireAuthHelper.getInstance().user?.uid)!
                
                self.db.collection(USER_FAVOURITES_COLLECTION)
                    .document(userID)
                    .collection(PROFILE_COLLECTION)
                    .limit(to: 1)
                    .addSnapshotListener({(DocumentSnapshot, error) in
                        //querySnapshot - query result set
                        
                        //check if result is not nil
                        guard let snapshot = DocumentSnapshot else {
                            print(#function, "No results received from firestore : \(error)")
                            return
                        }
                        
                        do {
                            self.userProfile = try snapshot.documents[0].data(as: Users.self)
                        } catch let error {
                            print(#function, "Unable to access document change : \(error)")
                        }
                        
                    })
            } catch let error {
                print(#function, "Unable to insert the document to firestore : \(error)")
            }
        }
    }
    
    func updateUserProfile(user : Users, completion: @escaping(Bool,String) -> Void){
        do {
            if (FireAuthHelper.getInstance().user == nil) {
                print(#function, "No logged in user")
            } else {
                let userID = (FireAuthHelper.getInstance().user?.uid)!
                
                self.db.collection(USER_FAVOURITES_COLLECTION)
                    .document(userID)
                    .collection(PROFILE_COLLECTION)
                    .document(userID)
                    .updateData(
                        [
                            FIELD_NAME : user.name,
                            FIELD_CONTACTNO : user.contactNo,
                            FIELD_PAYMENTINFO : user.paymentInfo
                        ]
                    ) { error in
                        if let err = error {
                            print(#function, "Unable to update document : \(error)")
                            completion(false, "Profile update failed...!!!")
                        } else {
                            completion(true, "Profile updated successfully...!!!")
                        }
                    }
            }
        } catch let error {
            print(#function,"Unable to update the document to firestore : \(error)")
        }
    }
}
