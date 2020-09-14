import SwiftUI

struct TimersView: View {
    @ObservedObject var counter = Counter.shared
    
    var body: some View {
        Form {
            Section(header: Text("Current")) {
                CountdownCell(countdown: counter.current)
            }
            
            if !counter.queue.isEmpty {
                Section(header: Text("Queue")) {
                    ForEach(counter.queue, id: \.self) { countdown in
                        Button { withAnimation { self.counter.load(countdown) } } label: {
                            CountdownCell(countdown: countdown)
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            
            Section {
                HStack {
                    HStack {
                        Spacer()
                        Button("Countdown") {
                            withAnimation {
                                counter.queue.append(Countdown(Length(timeInterval: 300)))
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        Button("Scheduled") {
                            withAnimation {
                                counter.queue.append(Countdown(Date().addingTimeInterval(300)))
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            counter.queue.remove(at: index)
        }
    }
}
