//
//  Avarage.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI

struct Avarage: View {
    
    let distancePerHour: String
    let sleepingHours: String
    
    private var avarageInformation: some View {
        HStack(spacing: 8) {
            createIcon(withImage: "figure.run")
            TextView(text: distancePerHour,
                     color: .white,
                     type: .title)
            Line(orienttion: .vertical,
                 withColor: Color(ColorConstant.PURPLE))
            createIcon(withImage: "bed.double.fill")
            TextView(text: sleepingHours,
                     color: .white,
                     type: .title)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            TextView(text: "Médias",
                     color: .white,
                     type: .secondValue)
            avarageInformation
        }
    }
    
    func createIcon(withImage image: String) -> some View {
        Image(systemName: image)
            .foregroundColor(Color(ColorConstant.PURPLE))
            .font(.system(size: 20, weight: .bold))
    }
}

struct Avarage_Previews: PreviewProvider {
    static var previews: some View {
        Avarage(distancePerHour: "19 km/h", sleepingHours: "5h")
    }
}
