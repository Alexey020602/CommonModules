//
// Created by Alexey on 21.12.2022.
//

import Foundation

protocol AnyOptional{
    var isNil:Bool{get}
}

extension Optional:AnyOptional{
    var isNil: Bool{
        self == nil
    }
}