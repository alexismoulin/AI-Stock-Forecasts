import SwiftUI

struct SectionRow: View {
    var company: Company

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(Int(company.totalScore))")
                .font(.title3.weight(.semibold))
                .frame(width: 36, height: 36)
                .mask(Circle())
                .padding(12)
                .background(Color(UIColor.systemBackground).opacity(0.3))
                .mask(Circle())
                .overlay(CircularView(value: company.calculatedScore))
            VStack(alignment: .leading, spacing: 4) {
                Image("\(company.hash)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                Text(company.name)
                    .fontWeight(.semibold)
                Text(company.id)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

struct SectionRow_Previews: PreviewProvider {
    static var previews: some View {
        SectionRow(company: Company.example)
    }
}
