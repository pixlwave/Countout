import SwiftUI

struct CountdownQueue: View {
    @ObservedObject var countdown = CountdownTimer.shared
    
    var body: some View {
        List {
            Section {
                CountdownCell(countdown: countdown.current)
            }
            
            Section {
                ForEach(countdown.queue, id: \.self) { countdown in
                    CountdownCell(countdown: countdown)
                        .onTapGesture { self.countdown.load(countdown) }
                }
                .onDelete(perform: delete)
            }
            
            Section {
                HStack {
                    HStack {
                        Spacer()
                        Text("Countdown")
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                    .onTapGesture {
                        countdown.queue.append(Countdown(Length(timeInterval: 300)))
                    }
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        Text("Scheduled")
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                    .onTapGesture {
                        countdown.queue.append(Countdown(Date().addingTimeInterval(300)))
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .overlay(Divider(), alignment: .top)
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            countdown.queue.remove(at: index)
        }
    }
}
