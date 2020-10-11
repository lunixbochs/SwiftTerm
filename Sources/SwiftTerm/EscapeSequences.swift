//
//  EscapeSequences.swift
//  SwiftTerm
//
//  Created by Miguel de Icaza on 3/30/19.
//  Copyright © 2019 Miguel de Icaza. All rights reserved.
//

import Foundation

struct ControlCodes {
    static let NUL: UInt8 = 0x00
    static let BEL: UInt8 = 0x07
    static let BS: UInt8 = 0x08
    static let HT: UInt8 = 0x09
    static let LF: UInt8 = 0x0A
    static let VT: UInt8 = 0x0B
    static let FF: UInt8 = 0x0C
    static let CR: UInt8 = 0x0D
    static let SO: UInt8 = 0x0E
    static let SI: UInt8 = 0x0F
    static let CAN: UInt8 = 0x18
    static let SUB: UInt8 = 0x1A
    static let ESC: UInt8 = 0x1B
    static let SP: UInt8 = 0x20
    static let DEL: UInt8 = 0x7F
}

/**
 * Control codes - this structure provides variables that will return strings that are either the 7-bit version of the sequence or the 8-bit one
 * See = https://en.wikipedia.org/wiki/C0_and_C1_control_codes
 */
struct CC {
    var send8bit: Bool

    var PAD: [UInt8] { send8bit ? [0x80] : [0x1B, 0x40] }
    var HOP: [UInt8] { send8bit ? [0x81] : [0x1B, 0x41] }
    var BPH: [UInt8] { send8bit ? [0x82] : [0x1B, 0x42] }
    var NBH: [UInt8] { send8bit ? [0x83] : [0x1B, 0x43] }
    var IND: [UInt8] { send8bit ? [0x84] : [0x1B, 0x44] }
    var NEL: [UInt8] { send8bit ? [0x85] : [0x1B, 0x45] }
    var SSA: [UInt8] { send8bit ? [0x86] : [0x1B, 0x46] }
    var ESA: [UInt8] { send8bit ? [0x87] : [0x1B, 0x47] }
    var HTS: [UInt8] { send8bit ? [0x88] : [0x1B, 0x48] }
    var HTJ: [UInt8] { send8bit ? [0x89] : [0x1B, 0x49] }
    var VTS: [UInt8] { send8bit ? [0x8A] : [0x1B, 0x4A] }
    var PLD: [UInt8] { send8bit ? [0x8B] : [0x1B, 0x4B] }
    var PLU: [UInt8] { send8bit ? [0x8C] : [0x1B, 0x4C] }
    var RI: [UInt8] { send8bit ? [0x8D] : [0x1B, 0x4D] }
    var SS2: [UInt8] { send8bit ? [0x8E] : [0x1B, 0x4E] }
    var SS3: [UInt8] { send8bit ? [0x8F] : [0x1B, 0x4F] }
    var DCS: [UInt8] { send8bit ? [0x90] : [0x1B, 0x50] }
    var PU1: [UInt8] { send8bit ? [0x91] : [0x1B, 0x51] }
    var PU2: [UInt8] { send8bit ? [0x92] : [0x1B, 0x52] }
    var STS: [UInt8] { send8bit ? [0x93] : [0x1B, 0x53] }
    var CCH: [UInt8] { send8bit ? [0x94] : [0x1B, 0x54] }
    var MW: [UInt8] { send8bit ? [0x95] : [0x1B, 0x55] }
    var SPA: [UInt8] { send8bit ? [0x96] : [0x1B, 0x56] }
    var EPA: [UInt8] { send8bit ? [0x97] : [0x1B, 0x57] }
    var SOS: [UInt8] { send8bit ? [0x98] : [0x1B, 0x58] }
    var SGCI: [UInt8] { send8bit ? [0x99] : [0x1B, 0x59] }
    var SCI: [UInt8] { send8bit ? [0x9A] : [0x1B, 0x5A] }
    var CSI: [UInt8] { send8bit ? [0x9B] : [0x1B, 0x5B] }
    var ST: [UInt8] { send8bit ? [0x9C] : [0x1B, 0x5C] }
    var OSC: [UInt8] { send8bit ? [0x9D] : [0x1B, 0x5D] }
    var PM: [UInt8] { send8bit ? [0x9E] : [0x1B, 0x5E] }
    var APC: [UInt8] { send8bit ? [0x9F] : [0x1B, 0x5F] }
}

struct EscapeSequences {
    public static let CmdNewline: [UInt8] = [10]
    public static let CmdRet: [UInt8] = [13]
    public static let CmdEsc: [UInt8] = [0x1B]
    public static let CmdDel: [UInt8] = [0x7F]
    public static let CmdDelKey: [UInt8] = [0x1B, 0x5B, 0x33, 0x7E]
    public static let MoveUpApp: [UInt8] = [0x1B, 0x4F, 0x41]
    public static let MoveUpNormal: [UInt8] = [0x1B, 0x5B, 0x41]
    public static let MoveDownApp: [UInt8] = [0x1B, 0x4F, 0x42]
    public static let MoveDownNormal: [UInt8] = [0x1B, 0x5B, 0x42]
    public static let MoveLeftApp: [UInt8] = [0x1B, 0x4F, 0x44]
    public static let MoveLeftNormal: [UInt8] = [0x1B, 0x5B, 0x44]
    public static let MoveRightApp: [UInt8] = [0x1B, 0x4F, 0x43]
    public static let MoveRightNormal: [UInt8] = [0x1B, 0x5B, 0x43]
    public static let MoveHomeApp: [UInt8] = [0x1B, 0x4F, 0x48]
    public static let MoveHomeNormal: [UInt8] = [0x1B, 0x5B, 0x48]
    public static let MoveEndApp: [UInt8] = [0x1B, 0x4F, 0x46]
    public static let MoveEndNormal: [UInt8] = [0x1B, 0x5B, 0x46]
    public static let CmdTab: [UInt8] = [9]
    public static let CmdBackTab: [UInt8] = [0x1B, 0x5B, 0x5A]
    public static let CmdPageUp: [UInt8] = [0x1B, 0x5B, 0x35, 0x7E]
    public static let CmdPageDown: [UInt8] = [0x1B, 0x5B, 0x36, 0x7E]

    public static let CmdF: [[UInt8]] = [
        [0x1B, 0x4F, 0x50], /* F1 */
        [0x1B, 0x4F, 0x51], /* F2 */
        [0x1B, 0x4F, 0x52], /* F3 */
        [0x1B, 0x4F, 0x53], /* F4 */
        [0x1B, 0x5B, 0x31, 0x35, 0x7E], /* F5 */
        [0x1B, 0x5B, 0x31, 0x37, 0x7E], /* F6 */
        [0x1B, 0x5B, 0x31, 0x38, 0x7E], /* F7 */
        [0x1B, 0x5B, 0x31, 0x39, 0x7E], /* F8 */
        [0x1B, 0x5B, 0x32, 0x30, 0x7E], /* F9 */
        [0x1B, 0x5B, 0x32, 0x31, 0x7E], /* F10 */
        [0x1B, 0x5B, 0x32, 0x33, 0x7E], /* F11 */
        [0x1B, 0x5B, 0x32, 0x34, 0x7E], /* F12 */
    ]
}
