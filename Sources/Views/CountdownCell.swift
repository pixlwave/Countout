import SwiftUI

struct CountdownCell: View {
    @ObservedObject var countdown: Countdown
    @State var isPresentingEditSheet = false
    
    var body: some View {
        HStack {
            Text(countdown.description)
                .foregroundColor(.primary)
            Spacer()
            Button { isPresentingEditSheet.toggle() } label: {
                Image(systemName: countdown.isScheduled ? "calendar" : "timer")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            NavigationView {
                EditView(countdown: countdown)
                    .navigationBarItems(trailing: Button("Done") {
                        isPresentingEditSheet.toggle()
                    })
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
