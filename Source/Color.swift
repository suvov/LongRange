//
//  Color.swift
//  LongRange
//
//  Created by Vladimir Shutyuk on 27/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//


#if os(macOS)
    import AppKit
    public typealias COLOR = NSColor
#else
    import UIKit
    public typealias COLOR = UIColor
#endif
