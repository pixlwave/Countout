import SwiftUI

struct CountdownCell: View {
    let countdown: Countdown
    
    @Namespace private var namespace
    @State private var isPresentingEditSheet = false
    private let editSheetID = "EditSheet"
    
    var body: some View {
        LabeledContent {
            Button(action: edit) {
                Image(systemName: countdown.isScheduled ? "calendar" : "timer")
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Button")
            .matchedTransitionSource(id: editSheetID, in: namespace)
        } label: {
            Text(countdown.description)
                .foregroundColor(.primary)
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            EditView(countdown: countdown)
                .navigationTransition(.zoom(sourceID: editSheetID, in: namespace))
        }
        .accessibilityLabel("Content")
        .accessibilityAction(named: "Edit", edit)
    }
    
    func edit() {
        isPresentingEditSheet = true
    }
}

// MARK: - Previews

#Preview {
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
