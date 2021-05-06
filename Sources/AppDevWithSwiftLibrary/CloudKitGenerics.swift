//
//  CloudKitGenerics.swift
//  Parliament
//
//  Created by Kevin McQuown on 1/15/21.
//

import Foundation
import CloudKit

//let iCloudContainer = "iCloud.com.thewcl.arti.EHealthMobile"

public protocol SimplyInitializable {
    init()
}

public protocol CloudKitProtocol: SimplyInitializable {
    associatedtype ModelType
    static func fromCloudKit(record: CKRecord) -> ModelType
    var cloudKit: CKRecord { get }
    var id: UUID { get }
}

public func getUserID(complete: @escaping (String) -> Void) {
    CKContainer.default().fetchUserRecordID { (recordID, error) in
        if let error = error {
            print(error.localizedDescription)
        } else {
            complete(recordID?.recordName ?? "no record name")
        }
    }
}

public func getCloudKitByIDs<T: CloudKitProtocol>(_ ids: [String], swiftType: T, complete: @escaping ([T]) -> Void) {
    var items = [T]()
    let group = DispatchGroup()
    
    for id in ids {
        group.enter()
        getCloudKitByID(id, dummy: T()) { (item) in
            if let item = item {
                items.append(item)
                group.leave()
            }
        }
    }
    group.notify(queue: .main) {
        DispatchQueue.main.async {
            complete(items)
        }
    }
}

public func getCloudKitByID<T: CloudKitProtocol>(_ id: String, dummy: T, complete: @escaping (T?) -> Void) {
    let id = CKRecord.ID(recordName: id)
    let container = CKContainer.default()
    container.publicCloudDatabase.fetch(withRecordID: id) { (ckrecord, error) in
        DispatchQueue.main.async {
            if let ckrecord = ckrecord {
                complete(T.fromCloudKit(record: ckrecord) as? T)
            } else {
                complete(nil)
            }
        }
    }
}
public func deleteCloudKitByID<T: CloudKitProtocol> (_ id: String, dummy: T, complete: @escaping () -> Void) {
    let id = CKRecord.ID(recordName: id)
    let container = CKContainer.default()
    container.publicCloudDatabase.delete(withRecordID: id) { (record, error) in
        if let error = error {
            print(error.localizedDescription)
        }
        DispatchQueue.main.async {
            complete()
        }
    }
}

public func createSubscription(recordType: String, predicate: NSPredicate, resultingSubscription: @escaping ((CKSubscription?, Error?) -> Void)) {
    let db = CKContainer.default().publicCloudDatabase
    let sub = CKQuerySubscription(recordType: recordType, predicate: predicate, options: [.firesOnRecordUpdate, .firesOnRecordCreation, .firesOnRecordDeletion])
    print("created subscription id: \(sub.subscriptionID)")
    let notification = CKSubscription.NotificationInfo()
    notification.shouldSendContentAvailable = true
    sub.notificationInfo = notification
    db.save(sub) { (subscription, error) in
        if let error = error {
            print("error creating subscription: \(error.localizedDescription)")
            resultingSubscription(nil, error)
             return
        }
        if let subscription = subscription {
            print("We have a subscription \(subscription.subscriptionID)")
            resultingSubscription(subscription, nil)
        }
    }
}

public func fetchAndRemoveAllCloudKitSubscriptions() {
    let db = CKContainer.default().publicCloudDatabase
    db.fetchAllSubscriptions { (subscriptions, error) in
        if let subscriptions = subscriptions {
            for sub in subscriptions {
                print("Removing subscription \(sub.subscriptionID) subscription.")
                db.delete(withSubscriptionID: sub.subscriptionID) { (result, error) in
                    ()
                }
            }
        }
    }
}

public func saveToICloud<T: CloudKitProtocol>(record: T, complete: @escaping (CKRecord?, Error?) -> Void) {
    let container = CKContainer.default()
    let id = CKRecord.ID(recordName: record.id.uuidString)
    container.publicCloudDatabase.fetch(withRecordID: id) { (ckrecord, error) in
        if var ckrecord = ckrecord {
            ckrecord = record.cloudKit
            let modifyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [ckrecord], recordIDsToDelete: [])
            modifyRecordsOperation.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.allKeys

            modifyRecordsOperation.modifyRecordsCompletionBlock = {record, recordIDs, error in
                if let err = error {
                    print ("Error: \(err.localizedDescription)")
                } else {
                    print ("Modified successful!: \(ckrecord.recordType.description) \(ckrecord.recordID.recordName)")
                }
                DispatchQueue.main.async {
                    complete(ckrecord, error)
                }
            }
            container.publicCloudDatabase.add(modifyRecordsOperation)
        } else {
            container.publicCloudDatabase.save(record.cloudKit) { record, error in
                DispatchQueue.main.async {
                    complete(record, error)
                }
            }
        }
    }
}

public func subscribeCloudKit<T: CloudKitProtocol>(recordType: String,
                                            dummy: T,
                                            fieldsToQuery: [String: Any?],
                                            complete: @escaping ((Error) -> Void)) {
    ()
}

public func queryCloudKit<T: CloudKitProtocol>(recordType: String,
                                        dummy: T,
                                        fieldsToQuery: [String: Any?],
                                        sortDescriptors: [NSSortDescriptor],
                                        cursor: CKQueryOperation.Cursor?,
                                        complete: @escaping (([T], Bool) -> Void)) {
    
    var predicates = [NSPredicate]()
    
    for (key, value) in fieldsToQuery {
        if value is String {
            predicates.append(NSPredicate(format: "%K = %@", key, value as! String))
        } else if value is Bool {
            predicates.append(NSPredicate(format: "%K = \(value as! Bool ? "YES" : "NO")", key))
        } else if value is Int {
            predicates.append(NSPredicate(format: "%K = %@", key, value as! Int))
        } else if value is Double {
            predicates.append(NSPredicate(format: "%K = %@", key, value as! Double))
        } else {
          //  print("not using \(key) \(value)")
        }
    }
    
    let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    let query = CKQuery(recordType: recordType, predicate: compound)
    query.sortDescriptors = sortDescriptors
    let queryOperation = CKQueryOperation(query: query)
    
    var items = [T]()
    if let cursor = cursor {
        queryOperation.cursor = cursor
    }
    
    queryOperation.recordFetchedBlock = { record in
        items.append(T.fromCloudKit(record: record) as! T)
    }
    queryOperation.queryCompletionBlock = { (cursor, error) in
        if let error = error {
            print("Error \(recordType): \(error.localizedDescription)")
        }
        if let cursor = cursor {
            let newQuery = CKQueryOperation(query: query)
            newQuery.recordFetchedBlock = queryOperation.recordFetchedBlock
            newQuery.queryCompletionBlock = queryOperation.queryCompletionBlock
            newQuery.cursor = cursor
            newQuery.qualityOfService = queryOperation.qualityOfService
            CKContainer.default().publicCloudDatabase.add(newQuery)
            let batch = items
            complete(batch, true)
            items.removeAll()
        } else {
            DispatchQueue.main.async {
                complete(items, false)
            }
        }
    }
    queryOperation.qualityOfService = .userInteractive
    CKContainer.default().publicCloudDatabase.add(queryOperation)
}

public func queryCloudKit<T: CloudKitProtocol>(recordType: String,
                                        swiftType: T, complete: @escaping (([T]) -> Void)) {
    queryCloudKit(recordType: recordType, swiftType: swiftType, fieldsToQuery: [:], sortDescriptors: []) { (results) in
        complete(results)
    }
}

public func queryCloudKit<T: CloudKitProtocol>(recordType: String,
                                        swiftType: T,
                                        fieldsToQuery: [String: Any?],
                                        sortDescriptors: [NSSortDescriptor], complete: @escaping (([T]) -> Void)) {
    
    print("query \(recordType)")
    var predicates = [NSPredicate]()
    
    for (key, value) in fieldsToQuery {
        if value is String {
            predicates.append(NSPredicate(format: "%K = %@", key, value as! String))
        } else if value is Bool {
            predicates.append(NSPredicate(format: "%K = \(value as! Bool ? "YES" : "NO")", key))
        } else if value is Int {
            predicates.append(NSPredicate(format: "%K = %@", key, value as! Int))
        } else if value is Double {
            predicates.append(NSPredicate(format: "%K = %@", key, value as! Double))
        } else {
          //  print("not using \(key) \(value)")
        }
    }
    
    let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    let query = CKQuery(recordType: recordType, predicate: compound)
    query.sortDescriptors = sortDescriptors
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.resultsLimit = 500
    
    var items = [T]()
    queryOperation.recordFetchedBlock = { record in
        items.append(T.fromCloudKit(record: record) as! T)
    }
    queryOperation.queryCompletionBlock = { (cursor, error) in
        if let error = error {
            print("Error \(recordType): \(error.localizedDescription)")
        }
        DispatchQueue.main.async {
            complete(items)
        }
    }
    queryOperation.qualityOfService = .userInteractive
    CKContainer.default().publicCloudDatabase.add(queryOperation)
}

// checking intersection of two string arrays
public func queryContainsCloudKit<T: CloudKitProtocol>(recordType: String,
                                        swiftType: T,
                                        key: String,
                                        values: [String],
                                        sortDescriptors: [NSSortDescriptor], complete: @escaping (([T]) -> Void)) {
    

    let predicate = NSPredicate(format: "\(key) CONTAINS %@", argumentArray: values)
    let query = CKQuery(recordType: recordType, predicate: predicate)
    query.sortDescriptors = sortDescriptors
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.resultsLimit = 50
    
    var items = [T]()
    queryOperation.recordFetchedBlock = { record in
        items.append(T.fromCloudKit(record: record) as! T)
    }
    queryOperation.queryCompletionBlock = { (cursor, error) in
        if let error = error {
            print("Error \(recordType): \(error.localizedDescription)")
        }
        DispatchQueue.main.async {
            complete(items)
        }
    }
    queryOperation.qualityOfService = .userInteractive
    CKContainer.default().publicCloudDatabase.add(queryOperation)
}

public func queryInCloudKit<T: CloudKitProtocol>(recordType: String,
                                        swiftType: T,
                                        key: String,
                                        values: [String],
                                        sortDescriptors: [NSSortDescriptor], complete: @escaping (([T]) -> Void)) {
    

    let predicate = NSPredicate(format: "\(key) == %@", argumentArray: values)
    let query = CKQuery(recordType: recordType, predicate: predicate)
    query.sortDescriptors = sortDescriptors
    let queryOperation = CKQueryOperation(query: query)
    queryOperation.resultsLimit = 50
    
    var items = [T]()
    queryOperation.recordFetchedBlock = { record in
        items.append(T.fromCloudKit(record: record) as! T)
    }
    queryOperation.queryCompletionBlock = { (cursor, error) in
        if let error = error {
            print(recordType)
            print(error.localizedDescription)
        }
        DispatchQueue.main.async {
            complete(items)
        }
    }
    queryOperation.qualityOfService = .userInteractive
    CKContainer.default().publicCloudDatabase.add(queryOperation)
}
