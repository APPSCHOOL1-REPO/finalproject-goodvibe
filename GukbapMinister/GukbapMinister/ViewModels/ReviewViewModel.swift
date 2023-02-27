//
//  CommentViewModel.swift
//  GukbapMinister
//
//  Created by Martin on 2023/01/16.
//
import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import Firebase
import Kingfisher
import FirebaseFirestoreSwift

//TODO: 서버에 등록된 모든 리뷰를 가져올게 아니라 특정 조건에 맞는 리뷰를 가지고올 필요가 있음
class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var latestReviews: [Review] = []

    @Published var reviewImage: [String : UIImage] = [:]
 //   @Published var documents: [DocumentSnapshot] = []
    let database = Firestore.firestore()
    let storage = Storage.storage()
    //    init() {
    //        reviews = []
    //    }
    
    //    var id: String
    //    var userId: String
    //    var reviewText: String
    //    var createdAt: Double
    //    var image: [String]?
    //    var nickName: String
    //    var createdDate: String
    //    var storeName: String
    func updateReviews(){
        
    }
    func fetchReviews() {
        
        database.collection("Review")
            .order(by: "createdAt", descending: true)
        
            .getDocuments { (snapshot, error) in
                self.reviews.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        
                        let id: String = document.documentID
                        let docData = document.data()
                        
                        let userId: String = docData["userId"] as? String ?? ""
                        let reviewText: String = docData["reviewText"] as? String ?? ""
                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
                        let images: [String] = docData["images"] as? [String] ?? []
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let starRating: Int = docData["starRating"] as? Int ?? 0
                        let storeName: String = docData["storeName"] as? String ?? ""
                        let storeId: String = docData["storeId"] as? String ?? ""

                        for imageName in images{
                            self.retrieveImages(reviewId: id, imageName: imageName)
                        }
                        
                        let review: Review = Review(id: id,
                                                    userId: userId,
                                                    reviewText: reviewText,
                                                    createdAt: createdAt,
                                                    images: images,
                                                    nickName: nickName,
                                                    starRating: starRating,
                                                    storeName: storeName,
                                                    storeId: storeId
                        )
                        self.reviews.append(review)
                    }
                }
            }
    }
    // MARK: 최신순 리뷰 보여주기
    func fetchLatestReviews() {
        
        database.collection("Review")
            .order(by: "createdAt", descending: true)
//            .start(afterDocument: documents.last!)
        
            .getDocuments { (snapshot, error) in
                self.latestReviews.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        
                        let id: String = document.documentID
                        let docData = document.data()
                        
                        let userId: String = docData["userId"] as? String ?? ""
                        let reviewText: String = docData["reviewText"] as? String ?? ""
                        let createdAt: Double = docData["createdAt"] as? Double ?? 0
                        let images: [String] = docData["images"] as? [String] ?? []
                        let nickName: String = docData["nickName"] as? String ?? ""
                        let starRating: Int = docData["starRating"] as? Int ?? 0
                        let storeName: String = docData["storeName"] as? String ?? ""
                        let storeId: String = docData["storeId"] as? String ?? ""

                        for imageName in images{
                            self.retrieveImages(reviewId: id, imageName: imageName)
                        }
                        
                        let review: Review = Review(id: id,
                                                    userId: userId,
                                                    reviewText: reviewText,
                                                    createdAt: createdAt,
                                                    images: images,
                                                    nickName: nickName,
                                                    starRating: starRating,
                                                    storeName: storeName,
                                                    storeId: storeId
                        )
                        self.latestReviews.append(review)
                    }
                }
            }
    }
    
    // MARK: - 서버의 Review Collection에 Review 객체 하나를 추가하여 업로드하는 Method
    func addReview(review: Review, images: [UIImage]) async {
        do {
            var imgNameList: [String] = []
            
            for img in images {
                let imgName = UUID().uuidString
                imgNameList.append(imgName)
                uploadImage(image: img, name: (review.id + "/" + imgName))
            }
            
            try await database.collection("Review")
                .document(review.id)
                .setData(["userId": review.userId,
                          "reviewText": review.reviewText,
                          "createdAt": review.createdAt,
                          "images": imgNameList,
                          "nickName": review.nickName,
                          "starRating": review.starRating,
                          "storeName" : review.storeName,
                          "storeId": review.storeId
                         ])
            
            await updateStoreRating(updatingReview: review, isDeleting: false)
            
            fetchReviews()
            fetchLatestReviews()

        } catch {
            print(error.localizedDescription)
        
        }
    
    }
    
    // MARK: - 서버의 Reviews Collection에서 Reviews 객체 하나를 삭제하는 Method
    func removeReview(review: Review) async {
        do {
            try await database.collection("Review")
                .document(review.id).delete()
            
            // remove photos from storage
            if let images = review.images {
                for image in images {
                    let imagesRef = storage.reference().child("images/\(review.id)/\(image)")
                    imagesRef.delete { error in
                        if let error = error {
                            print("Error removing image from storage\n\(error.localizedDescription)")
                        } else {
                            print("images directory deleted successfully")
                        }
                    }
                }
            }
            
            await updateStoreRating(updatingReview: review, isDeleting: true)
            
            fetchReviews()
            fetchLatestReviews()

        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - 서버의 Storage에 이미지를 업로드하는 Method
    func uploadImage(image: UIImage, name: String) {
        let storageRef = storage.reference().child("images/\(name)")
        let data = image.jpegData(compressionQuality: 0.1)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        // uploda data
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, err) in
                
                if let err = err {
                    print("err when uploading jpg\n\(err)")
                }
                
                if let metadata = metadata {
                    print("metadata: \(metadata)")
                }
            }
        }
        
    }

    
    // MARK: - 서버의 Storage에서 이미지를 가져오는 Method
    func retrieveImages(reviewId: String, imageName: String) {
        let ref = storage.reference().child("images/\(reviewId)/\(imageName)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        ref.getData(maxSize: 15 * 1024 * 1024) { data, error in
            if let error = error {
                print("error while downloading image\n\(error.localizedDescription)")
                return
            } else {
                let image = UIImage(data: data!)
                self.reviewImage[imageName] = image
            }
        }
    }
    

    func updateStoreRating(updatingReview: Review, isDeleting: Bool) async {
        let storeReviews = reviews.filter { $0.storeName == updatingReview.storeName }
        var reviewCount = storeReviews.count
        var ratingSum: Int = storeReviews.reduce(0) { $0 + $1.starRating}
        var newRatingAverage: Double
        
        if isDeleting {
            reviewCount -= 1
            ratingSum -= updatingReview.starRating
        } else {
            reviewCount += 1
            ratingSum += updatingReview.starRating
        }
        
      
        if reviewCount != 0 {
            newRatingAverage = Double(ratingSum) / Double(reviewCount)
        } else {
            newRatingAverage = 0
        }
        
        
        do {
            try await database.collection("Store").document(updatingReview.storeId).updateData([
                "countingStar" : newRatingAverage
            ])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}
