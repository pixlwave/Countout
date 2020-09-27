import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown: Countdown
    @State var isPresentingEditSheet = false
    
    var body: some View {
        HStack {
            Text(countdown.description)
                .foregroundColor(.primary)
            Spacer()
            Button { isPresentingEditSheet = true } label: {
                Image(systemName: countdown.isScheduled ? "calendar" : "timer")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            NavigationView {
                EditView(countdown: countdown)
                    .foregroundColor(.primary)
                    // removed whilst there's a bug with text fields that prevents done from working
                    // .navigationBarItems(trailing: Button("Done") { isPresentingEditSheet = false })
            }
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
