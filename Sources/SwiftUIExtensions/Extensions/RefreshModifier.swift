//
//  RefreshModifier.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 19.04.2023.
//

import SwiftUI
import Introspect

private struct PullToRefresh: UIViewRepresentable {
    
    @State var isShowing: Bool = false
    let onRefresh: () async -> Void
    
    public init(
        onRefresh: @escaping () async -> Void
    ) {
        self.onRefresh = onRefresh
    }
    
    public class Coordinator {
        let onRefresh: () async -> Void
        let isShowing: Binding<Bool>
        
        init(
            onRefresh: @escaping () async -> Void,
            isShowing: Binding<Bool>
        ) {
            self.onRefresh = onRefresh
            self.isShowing = isShowing
        }
        
        @objc
        func onValueChanged() {
            Task{
                isShowing.wrappedValue = true
                await onRefresh()
                isShowing.wrappedValue = false
            }
        }
    }
    
    public func makeUIView(context: UIViewRepresentableContext<PullToRefresh>) -> UIView {
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }
    
    private func scrollView(entry: UIView) -> UIScrollView? {
        
        // Search in ancestors
        if let scrollView = Introspect.findAncestorOrAncestorChild(ofType: UIScrollView.self, from: entry) {
            return scrollView
        }

        guard let viewHost = Introspect.findViewHost(from: entry) else {
            return nil
        }

        // Search in siblings
        return Introspect.previousSibling(containing: UIScrollView.self, from: viewHost)
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PullToRefresh>) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            
            guard let scrollView = self.scrollView(entry: uiView) else {
                return
            }
            
            if let refreshControl = scrollView.refreshControl {
                if self.isShowing {
                    refreshControl.beginRefreshing()
                } else {
                    refreshControl.endRefreshing()
                }
                return
            }
            
            let refreshControl = UIRefreshControl()
            if let collectionView = scrollView as? UICollectionView{
                collectionView.alwaysBounceVertical = true
            }
            refreshControl.isUserInteractionEnabled = false
            refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.onValueChanged), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(onRefresh: onRefresh, isShowing: $isShowing)
    }
}

public extension View {
    @available(iOS, obsoleted:16)
    func refreshable(action: @escaping () async -> Void) -> some View {
        return overlay(
            PullToRefresh(onRefresh: action)
                .frame(width: 0, height: 0)
        )
    }
}
