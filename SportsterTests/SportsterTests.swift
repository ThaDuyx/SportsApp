//
//  SportsterTests.swift
//  SportsterTests
//
//  Created by Simon Andersen on 29/09/2020.
//

import XCTest
@testable import Sportster
import Firebase

class SportsterTests: XCTestCase {


    func testRetrievalOfUser() throws {
        let FirebaseReference = Firestore.firestore().collection("unittest")
        let assertUser = User(uid: "dummyuser", email: "dummy@dummy.com", name: "dummyuser", location: "dummylocation", description: "i am a dummy", interests: ["Boldsport", "Cykling", "Skating"], events: [], pfimage: UIImage())
        FirebaseReference.document("dummyuser").getDocument { (dummySnapshot, error) in
            if error != nil {
                print("Something went wrong: Retrieving dummy user")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                let dummyData = dummySnapshot?.data()
                let dummyName = dummyData!["name"] as! String
                let dummyID = dummyData!["uid"] as! String
                let dummyLocation = dummyData!["location"] as! String
                let dummyInterests = dummyData!["interests"] as! [String]
                let dummyEmail = dummyData!["email"] as! String
                let dummyDescription = dummyData!["description"] as! String
                let dummyUser = User(uid: dummyID, email: dummyEmail, name: dummyName, location: dummyLocation, description: dummyDescription, interests: dummyInterests, events: [], pfimage: UIImage())
                XCTAssertEqual(assertUser?.uid, dummyUser?.uid)
                XCTAssertEqual(assertUser?.email, dummyUser?.email)
                XCTAssertEqual(assertUser?.location, dummyUser?.location)
                XCTAssertEqual(assertUser?.name, dummyUser?.name)
                XCTAssertEqual(assertUser?.events, dummyUser?.events)
                XCTAssertEqual(assertUser?.interests, dummyUser?.interests)
            }
        }
    }
    
    func testRetrievalofEvent() throws {
        let FirebaseReference = Firestore.firestore().collection("unittest")
        let assertEvent = Event(oid: "dummy", eid: "dummy", title: "dummy", date: "dummy", description: "dummy", interest: "dummy", location: "dummy", ownerName: "dummy", eImage: UIImage(), oImage: UIImage())
        FirebaseReference.document("dummyevent").getDocument { (dummyEventSnapshot, error) in
            if error != nil {
                print("Something went wrong: Retrieving event")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                let dummyEventData = dummyEventSnapshot?.data()
                let dummyEventOid = dummyEventData!["oid"] as! String
                let dummyEventEid = dummyEventData!["eid"] as! String
                let dummyEventLocation = dummyEventData!["location"] as! String
                let dummyEventOwnerName = dummyEventData!["ownername"] as! String
                let dummyEventTitle = dummyEventData!["title"] as! String
                let dummyEventDate = dummyEventData!["date"] as! String
                let dummyEventDescription = dummyEventData!["description"] as! String
                let dummyEventInterest = dummyEventData!["interests"] as! String
                let dummyEvent = Event(oid: dummyEventOid, eid: dummyEventEid, title: dummyEventTitle, date: dummyEventDate, description: dummyEventDescription, interest: dummyEventInterest, location: dummyEventLocation, ownerName: dummyEventOwnerName, eImage: UIImage(), oImage: UIImage())
                
                XCTAssertEqual(assertEvent?.eid, dummyEvent?.eid)
                XCTAssertEqual(assertEvent?.oid, dummyEvent?.oid)
                XCTAssertEqual(assertEvent?.title, dummyEvent?.title)
                XCTAssertEqual(assertEvent?.location, dummyEvent?.location)
                XCTAssertEqual(assertEvent?.ownerName, dummyEvent?.ownerName)
                XCTAssertEqual(assertEvent?.date, dummyEvent?.date)
                XCTAssertEqual(assertEvent?.description, dummyEvent?.description)
                XCTAssertEqual(assertEvent?.interest, dummyEvent?.interest)
            }
        }
        
    }

    func testPerformance() throws {
        //Testing the time that the images will take to download
        let expectation = XCTestExpectation(description: "Profile Image Test")
        let storageInstantiation = Storage.storage()
        let storageReference = storageInstantiation.reference()
        let ImageReference = storageReference.child("eventImages/dummyPhoto.jpeg")
        ImageReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("Something went wrong: Retrieving the dummy photo")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                XCTAssertNotNil(data, "Did not fulfill the requirements")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    
}
