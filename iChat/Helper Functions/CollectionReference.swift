//
//  CollectionReference.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-05-01.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}
