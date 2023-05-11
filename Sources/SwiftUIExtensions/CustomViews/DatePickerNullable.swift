//
//  DatePickerNullable.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 09.05.2023.
//

import SwiftUI
import FoundationExtensions

public struct DatePickerNullable: View {
    public let title:String
    public var selection:Binding<Date?>!
    public let dateStyle:DateFormatter.Style
    public let timeStyle:DateFormatter.Style
    public let displayedComponents:DatePickerComponents
    @State private var openDateSelection = false
    
    public init(
        title: String,
        selection: Binding<Date?>,
        dateStyle: DateFormatter.Style = .long,
        timeStyle: DateFormatter.Style = .medium,
        displayedComponents: DatePickerComponents = .date) {
        self.title = title
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
        self.displayedComponents = displayedComponents
        self.openDateSelection = openDateSelection
            self.selection = selection
    }
    
    public var body: some View {
        VStack{
            Text(title)
            HStack{
                if displayedComponents.contains(.date){
                    Text(selection.wrappedValue?.string(dateStyle: dateStyle, timeStyle: .none) ?? "Выбор даты")
                        .padding(10)
                        .background(Color.appGray)
                        .cornerRadius(10)
                        .foregroundColor(.appBlack)
                        .onTapGesture {
                            openDateSelection.toggle()
                        }
                }
                Spacer()
                if displayedComponents.contains(.hourAndMinute){
                    Text(selection.wrappedValue?.string(dateStyle: .none, timeStyle: timeStyle) ?? "Выбор времени")
                        .padding(10)
                        .background(Color.appGray)
                        .cornerRadius(10)
                        .foregroundColor(.appBlack)
                        .onTapGesture {
                            openDateSelection.toggle()
                        }
                }
                Spacer()
                if selection.wrappedValue != nil{
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 27))
                        .foregroundColor(.appGray)
                        .onTapGesture {
                            selection.wrappedValue = nil
                        }
                }
            }
            .padding(10)
            if openDateSelection{
                DatePicker(selection: selection ?? Date(), displayedComponents: displayedComponents) {}.datePickerStyle(.graphical)
            }
        }
    }
}
#if DEBUG
struct DatePickerNullable_Previews: PreviewProvider {
    @State static var date:Date? = Date()

    static var previews: some View {
        Form{
            DatePickerNullable(title: "TGgs", selection: $date, displayedComponents: [.date, .hourAndMinute])
            Text("")
        }
        
    }
}
#endif
