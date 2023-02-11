import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown: Countdown
    @State var isPresentingEditSheet = false
    
    var body: some View {
        LabeledContent {
            Button { isPresentingEditSheet = true } label: {
                Image(systemName: countdown.isScheduled ? "calendar" : "timer")
            }
            .buttonStyle(.borderless)
        } label: {
            Text(countdown.description)
                .foregroundColor(.primary)
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            EditView(countdown: countdown)
        }
    }
}

struct CountdownCell_Previews: PreviewProvider {
    
    static var previews: some View {
        Form {
            Section {
                CountdownCell(countdown: Countdown(Length(timeInterval: 300)))
            }
            
            Section {
                Button { } label: {
                    CountdownCell(countdown: Countdown(Date()))
                }
                
                Button { } label: {
                    CountdownCell(countdown: Countdown(Length(timeInterval: 1200)))
                }
            }
        }
    }
}
