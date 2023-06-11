import SwiftUI

struct CountdownCell: View {
    let countdown: Countdown
    @State var isPresentingEditSheet = false
    
    var body: some View {
        LabeledContent {
            Button(action: edit) {
                Image(systemName: countdown.isScheduled ? "calendar" : "timer")
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Button")
        } label: {
            Text(countdown.description)
                .foregroundColor(.primary)
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            EditView(countdown: countdown)
        }
        .accessibilityLabel("Content")
        .accessibilityAction(named: "Edit", edit)
    }
    
    func edit() {
        isPresentingEditSheet = true
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
