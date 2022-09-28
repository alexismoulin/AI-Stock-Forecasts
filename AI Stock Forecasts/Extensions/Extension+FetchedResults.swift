import Foundation
import SwiftUI

extension FetchedResults where Result == CustomCompany {
    func loadCustomCompanies() -> [Company] {
        var companies: [Company] = []
        for result in self {
            companies.append(Company(customCompany: result))
        }
        return companies
    }
}
