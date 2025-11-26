import SwiftUI

struct LearnView: View {
    var body: some View {
        List {
            Section("About the Cretaceous Era") {
                Text("The Cretaceous period was the last period of the Mesozoic era, lasting from about 145 to 66 million years ago. It ended with a mass extinction event that wiped out most non-avian dinosaurs and many marine species.")
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("• The Cretaceous was the final period of the Mesozoic Era")
                Text("• Many famous dinosaurs like T-Rex and Triceratops lived during this time")
                Text("• The period ended with a massive asteroid impact")
                Text("• Flowering plants first appeared during the Cretaceous")
                Text("• The climate was generally warmer than today")
            }
        }
        .navigationTitle("Learn")
    }
}
