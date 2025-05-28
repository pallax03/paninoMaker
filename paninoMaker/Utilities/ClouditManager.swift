//
//  ClouditManager.swift
//  paninoMaker
//
//  Created by alex mazzoni on 28/05/25.
//

import CloudKit

class CloudKitManager {
    private let container: CKContainer
    private let publicDB: CKDatabase

    init(containerIdentifier: String? = nil) {
        if let id = containerIdentifier {
            container = CKContainer(identifier: id)
        } else {
            container = CKContainer.default()
        }
        publicDB = container.publicCloudDatabase
    }

    func fetchUserData() async throws -> UserData {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "UserData", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var fetchedRecord: CKRecord?

        queryOperation.recordMatchedBlock = { recordID, result in
            if case .success(let record) = result {
                fetchedRecord = record
            }
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queryOperation.queryResultBlock = { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            publicDB.add(queryOperation)
        }

        guard let record = fetchedRecord,
              let level = record["level"] as? Int,
              let pex = record["pex"] as? Int else {
            throw NSError(domain: "CloudKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Malformed record"])
        }
        
        let username = record["username"] as? String

        return UserData(username: username, level: level, pex: pex)
    }
    
    func saveUserData(_ userData: UserData) async throws {
        let recordID = CKRecord.ID(recordName: "currentUserData")
        let record = CKRecord(recordType: "UserData", recordID: recordID)
        record["username"] = userData.username as CKRecordValue?
        record["level"] = userData.level as CKRecordValue
        record["pex"] = userData.pex as CKRecordValue

        try await publicDB.save(record)
    }
}
