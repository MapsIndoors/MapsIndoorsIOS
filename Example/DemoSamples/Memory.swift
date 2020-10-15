//
//  TestMemory.swift
//  DemosUITests
//
//  Created by Daniel Nielsen on 09/08/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

import UIKit

///https://stackoverflow.com/questions/787160/programmatically-retrieve-memory-usage-on-iphone/6627707

class Memory: NSObject {
    
    // From Quinn the Eskimo at Apple.
    // https://forums.developer.apple.com/thread/105088#357415
    
    class func memoryFootprint() -> Int64 {
        // The `TASK_VM_INFO_COUNT` and `TASK_VM_INFO_REV1_COUNT` macros are too
        // complex for the Swift C importer, so we have to define them ourselves.
        let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let TASK_VM_INFO_REV1_COUNT = mach_msg_type_number_t(MemoryLayout.offset(of: \task_vm_info_data_t.min_address)! / MemoryLayout<integer_t>.size)
        var info = task_vm_info_data_t()
        var count = TASK_VM_INFO_COUNT
        let kr = withUnsafeMutablePointer(to: &info) { infoPtr in
            infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
            }
        }
        guard
            kr == KERN_SUCCESS,
            count >= TASK_VM_INFO_REV1_COUNT
            else { return -1 }

        return Int64(info.phys_footprint)
    }
    
    class func formattedMemoryFootprint() -> String {
        return ByteCountFormatter.string(fromByteCount: self.memoryFootprint(), countStyle: .memory)
    }
}
