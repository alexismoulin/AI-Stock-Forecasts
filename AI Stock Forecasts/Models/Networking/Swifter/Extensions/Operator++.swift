import Foundation

/// If `rhs` is not `nil`, assign it to `lhs`.
// { associativity right precedence 90 assignment } // matches other assignment operators
infix operator ??= : AssignmentPrecedence

/// If `rhs` is not `nil`, assign it to `lhs`.
func ??= <T>(lhs: inout T?, rhs: T?) {
    guard let rhs = rhs else { return }
    lhs = rhs
}
