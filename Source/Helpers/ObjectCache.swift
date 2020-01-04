//
//  ObjectCache.swift
//  Benji
//
//  Created by Benji Dodgson on 1/4/20.
//  Copyright © 2020 Benjamin Dodgson. All rights reserved.
//

import Foundation

struct ObjectCreator<ObjectType: Hashable> {
    var cacheID: String
    var create: () -> ObjectType
}

/// A temporary cache for objects of a specified type. When requesting an object, an object creator
/// is passed in. If the object is not cached, the object creator's create function is used
/// then the returned object is cached.
class ObjectCache<ObjectType: Hashable> {

    private var cachedObjects: [String: ObjectType] = [:]

    func getObject(with creator: ObjectCreator<ObjectType>) -> ObjectType {
        // Attempt to get the object in the cache before creating a new one
        if let object = self.cachedObjects[creator.cacheID] {
            return object
        }

        let newObject = creator.create()
        self.cachedObjects[creator.cacheID] = newObject
        return newObject
    }

    func getObjects(with creators: [ObjectCreator<ObjectType>]) -> [ObjectType] {
        return creators.map { (objectCreator) -> ObjectType in
            return self.getObject(with: objectCreator)
        }
    }
}
