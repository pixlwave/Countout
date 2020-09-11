import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown: Countdown
    @State var isPresentingEditSheet = false
    
    var body: some View {
        HStack {
            Text(countdown.description)
                .foregroundColor(.primary)
            Spacer()
            Button("Edit") { isPresentingEditSheet.toggle() }
                .buttonStyle(BorderlessButtonStyle())
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            if countdown.isScheduled {
                DateCell(countdown: countdown)
            } else {
                LengthCell(countdown: countdown)
            }
        }
    }
}

struct CountdownCell_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            CountdownCell(countdown: Countdown(Date()))
        }
    }
}
