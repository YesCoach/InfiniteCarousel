//
//  Extension+CNContact.swift
//  InfiniteCarousel
//
//  Created by Twave on 2022/07/20.
//

import Foundation
import ContactsUI

extension CNContact {
    func name() -> String {
        return self.familyName + self.givenName
    }
    
    static func < (lhd: CNContact, rhd: CNContact) -> Bool {
        let lhdName = lhd.name()
        let rhdName = rhd.name()
        
        return lhdName < rhdName
    }
}
