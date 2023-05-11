//
// Created by Alexey on 09.02.2023.
//

import SwiftUI

public enum ListType {
    case inline
    case roundedCorners
    case divided(CGFloat)
}

struct ListCell<Content: View>: View {
    let addArrow: Bool
    let content: Content

    init(
            _ addArrow: Bool = false,
            content: () -> Content
    ) {
        self.addArrow = addArrow
        self.content = content()
    }

    var body: some View {
        HStack {
            content
            if addArrow {
                Image(systemName: "chevron.forward")
            }
        }
    }
}

struct CustomForEach<Item:Identifiable, Content:View>:View{
    let items:[Item]
    let addDivider:Bool
    let content:(Item) -> Content
    init(
            _ items:[Item],
            addDivider:Bool = true,
            @ViewBuilder content:@escaping (Item) -> Content
    ){
        self.items = items
        self.addDivider = addDivider
        self.content = content
    }
    var body: some View{
        ForEach(items) { item in
        content(item)
        if addDivider && (items.last?.id != item.id) {
            Divider()
        }
    }
    }
}

public struct CustomList<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
    let type: ListType
    let addArrows: Bool
    let addDivider:Bool

    public init(
            items: [Item],
            type: ListType = .roundedCorners,
            addArrows: Bool = false,
            addDivider:Bool = true,
            @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.type = type
        self.addArrows = addArrows
        self.addDivider = addDivider
        self.content = content
    }

    public var body: some View {
        ScrollView {
            switch type{
            case .inline:
                CustomForEach(items, addDivider: addDivider) { item in
                    ListCell(addArrows) {
                        content(item)
                    }
                }
            case .roundedCorners:
                CustomForEach(items, addDivider: addDivider) { item in
                    ListCell(addArrows) {
                        content(item)
                    }
                }
                        .cellView()
            case .divided(let padding):
                CustomForEach(items, addDivider: addDivider){ item in
                    ListCell(addArrows){
                        content(item)
                            .padding(padding)
                    }
                }
            }

        }

    }
}

