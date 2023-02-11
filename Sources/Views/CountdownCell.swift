import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown: Countdown
    @State var isPresentingEditSheet = false
    
    var body: some View {
        LabeledContent(countdown.description) {
            Button { isPresentingEditSheet = true } label: {
                Image(systemName: countdown.isScheduled ? "calendar" : "timer")
            }
            .buttonStyle(.borderless)
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            EditView(countdown: countdown)
        }
    }
}

struct CountdownCell_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            CountdownCell(countdown: Countdown(Length(timeInterval: 300)))
            CountdownCell(countdown: Countdown(Date()))
        }
    }
}
