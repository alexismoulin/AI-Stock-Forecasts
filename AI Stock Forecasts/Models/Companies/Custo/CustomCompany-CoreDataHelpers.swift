import Foundation

extension CustomCompany {
    public var wrappedArobase: String {
        arobase ?? "Unknown @"
    }
    
    public var wrappedId: String {
        id ?? "Unknown Stock Symbol"
    }
    
    public var wrappedName: String {
        name ?? "Unknown Company Name"
    }
    
    public var wrappedSector: String {
        sector ?? "Unknown Sector"
    }
    
    public var wrappedHash: String {
        "#\(wrappedId)"
    }
}
