//
//  Avarage.swift
//  challenge-catar Watch App
//
//  Created by alexdamascena on 29/11/22.
//

import SwiftUI

struct Average: View {
    
    let distancePerHour: String
    let sleepingHours: String
    
    private struct Constant {
        static let RUNNING = "figure.run"
        static let BED = "bed.double.fill"
    }
    
    private var averageInformation: some View {
        HStack(spacing: 8) {
            createIcon(withImage: Constant.RUNNING)
            TextView(text: distancePerHour,
                     color: .white,
                     type: .title)
            Line(orienttion: .vertical,
                 withColor: Color(ColorConstant.PURPLE))
            createIcon(withImage: Constant.BED )
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
            averageInformation
        }
    }
    
    func createIcon(withImage image: String) -> some View {
        Image(systemName: image)
            .foregroundColor(Color(ColorConstant.PURPLE))
            .font(.system(size: 20, weight: .bold))
    }
}

struct Average_Previews: PreviewProvider {
    static var previews: some View {
        Average(distancePerHour: "19 km/h", sleepingHours: "5h")
    }
}
