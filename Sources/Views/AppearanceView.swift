import SwiftUI

struct AppearanceView: View {
    @Binding var isPresented: Bool
    @ObservedObject var appearance = Appearance.shared
    @State private var isPresentingPhotoPicker = false
    @State private var isLoadingPhoto = false
    
    var body: some View {
        NavigationView {
            VStack {
                CountdownView()
                    .cornerRadius(7)
                    .padding()
                
                Spacer()
                
                ScrollView {
                    GroupBox(label: Text("Font")) {
                        Picker("Style", selection: $appearance.fontStyle) {
                            Text("Normal").tag(Appearance.FontStyle.normal)
                            Text("Light").tag(Appearance.FontStyle.light)
                            Text("Serif").tag(Appearance.FontStyle.serif)
                            Text("Rounded").tag(Appearance.FontStyle.rounded)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Slider(value: $appearance.fontScale, in: 0.1...0.4) {
                            Text("Size")
                        }
                        ColorPicker("Colour", selection: $appearance.textColor)
                    }
                    .padding(.horizontal)
                    
                    GroupBox(label: Text("Background")) {
                        ColorPicker("Background", selection: $appearance.backgroundColor)
                        
                        HStack {
                            Text("Image")
                            Spacer()
                            Button("Load") {
                                isPresentingPhotoPicker = true
                            }.padding(.horizontal)
                            Button("Clear") {
                                appearance.backgroundImageData = nil
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    GroupBox(label: Text("Triggers")) {
                        ColorPicker("Warning", selection: $appearance.earlyWarningColor)
                        ColorPicker("Finished", selection: $appearance.finalWarningColor)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarTitle("Appearance", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") { appearance.reset() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { isPresented = false }
                }
            }
            .sheet(isPresented: $isPresentingPhotoPicker) {
                PhotoPicker(isLoadingPhoto: $isLoadingPhoto)
                    .overlay(
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.black.opacity(0.3))
                            ProgressView("Loading")
                                .padding()
                                .background(Color.background)
                                .cornerRadius(15)
                        }
                        .opacity(isLoadingPhoto ? 1 : 0)
                    )
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
