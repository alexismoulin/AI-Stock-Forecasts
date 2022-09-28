import Foundation

extension Array where Element == BaseCompany {
    func loadBaseCompanies() -> [Company] {
        var companies: [Company] = []
        for element in self {
            companies.append(Company(baseCompany: element))
        }
        return companies
    }
}

extension Array where Element == CustomCompany {
    func loadCustomCompanies() -> [Company] {
        var companies: [Company] = []
        for element in self {
            companies.append(Company(customCompany: element))
        }
        return companies
    }
}

extension Array where Element == String {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
