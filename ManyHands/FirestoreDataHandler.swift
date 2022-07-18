//
//  FirestoreDataHandler.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 18/07/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirestoreDataHandler {
        
    static func addEntryToFirestore(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        let db = Firestore.firestore()
        let customId = ShortCode.randomStringWithLength(len: 5)

        let productData = ["description" : "A red dress",
                           "entryDate":Date.now,
                           "name":"Red dress",
                           "owner":"/users/\(user.uid)"
        ] as [String : Any]
        let newProduct = db.collection(DatabaseCollections.products).addDocument(data: productData) { error in
            if let error = error {
                print("add product failed with error:\(error.localizedDescription)")
            }
            else {
                print("add product succeedeed")
            }
        }
        
        
//        let newProduct = db.collection(FirestoreCollection.products).document() // Adds a new document
//        newProduct.setData(["data":"test"])
//        let productId = newProduct.documentID
//        db.collection(FirestoreCollection.products).document(productId).setData(["hello":"hello"], merge: true) // Does not delete existing fields
        
    }
    
    static func deleteProduct(with id:String){
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products).document(id).delete { error in
            if let error = error {
                print("delete product failed with error:\(error.localizedDescription)")
            }
            else {
                print("delete product succeedeed")
            }
        }
    }
    
    static func deleteProductField(field:String, with id:String){
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products).document(id).updateData([field:FieldValue.delete()])
    }
    
    static func getProduct(with id:String){
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products).document(id).getDocument { document, error in
            if let error = error {
                print("get product failed with error:\(error.localizedDescription)")
            }
            else {
                print("get product succeedeed")
                guard let document = document else {
                    return
                }

                if (document.exists) {
                    let documentData = document.data()
                }
            }
        }
    }
    
    static func getAllProducts(){
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products).getDocuments { snapshot, error in
            if let error = error {
                print("get products failed with error:\(error.localizedDescription)")
            }
            else {
                print("get products succeedeed")
                guard let snapshot = snapshot else {
                    return
                }

                for document in snapshot.documents {
                    let documentData = document.data()
                }
            }
        }
    }
    
    static func getUserProducts(){
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products).whereField("userId", isEqualTo: Auth.auth().currentUser?.uid).getDocuments { snapshot, error in
            if let error = error {
                print("get products failed with error:\(error.localizedDescription)")
            }
            else {
                print("get products succeedeed")
                guard let snapshot = snapshot else {
                    return
                }

                for document in snapshot.documents {
                    let documentData = document.data()
                }
            }
        }
    }
}
