import SwiftUI

struct AppearanceView: View {
    @Binding var isPresented: Bool
    @ObservedObject var appearance = Appearance.shared
    @State private var isPresentingPhotoPicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                CountdownView()
                    .padding(.horizontal)
                
                Spacer()
                GroupBox(label: Text("Font")) {
                    HStack {
                        Slider(value: $appearance.fontScale, in: 0.1...0.4) {
                            Text("Size")
                        }
                        Button(action: appearance.toggleBold) {
                            Text("Bold")
                        }
                    }
                    ColorPicker("Colour", selection: $appearance.textColor)
                        .frame(height: 32)
                }
                GroupBox(label: Text("Background")) {
                    ColorPicker("Background", selection: $appearance.backgroundColor)
                        .frame(height: 32)
                    HStack {
                        Text("Image")
                        Spacer()
                        Button("Load") {
                            isPresentingPhotoPicker = true
                        }.padding(.horizontal)
                        Button("Clear") {
                            appearance.backgroundImage = nil
                        }
                    }

                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Appearance", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button("Reset") {
                                        appearance.reset()
                                    }.font(.body),
                                trailing: Button("Done") {
                                    isPresented = false
                                })
            .sheet(isPresented: $isPresentingPhotoPicker) {
                PhotoPicker(isPresented: $isPresentingPhotoPicker)
            }
        }
    }
}

struct AppearanceView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        AppearanceView(isPresented: $isPresented)
    }
}
