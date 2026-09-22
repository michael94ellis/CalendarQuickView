import EventKit
import SwiftUI

struct CalendCalendarRowView: View {
    let calendar: EKCalendar
    let visibilityBinding: (EKCalendar) -> Binding<Bool>
    
    var body: some View {
        Toggle(isOn: visibilityBinding(calendar)) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color(nsColor: calendar.color))
                    .frame(width: 10, height: 10)
                Text(calendar.title)
                Spacer()
            }
            .padding(.leading, 4)
        }
        .toggleStyle(.checkbox)
        .padding(.vertical, 8)
    }
}
