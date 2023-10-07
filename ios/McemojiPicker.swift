import MCEmojiPicker

// This is a copy from MCEmojiPicker due to not publicly exported
extension NSNotification.Name {
    static let MCEmojiPickerDidDisappear = NSNotification.Name("MCEmojiPickerDidDisappear")
}

@objc(McemojiPickerViewManager)
class McemojiPickerViewManager: RCTViewManager {
    // Not work
    // override var methodQueue: DispatchQueue! {
    //     return DispatchQueue.main
    // }

    override func view() -> (McemojiPickerView) {
        let view = McemojiPickerView()
        // Props here are not the values set from js side, these are the initial values from McemojiPickerView
        // print("props: ", view.onSelect)
        view.viewController = McemojiPickerViewController()
        return view;
    }

    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc func open(_ tag: NSNumber, forAnchor anchor: NSNumber) {
        DispatchQueue.main.async { [self] in
            let rctView = getRCTView(tag: tag);
            let anchorView = bridge.uiManager.view(forReactTag: anchor);
            rctView.viewController.open(view: anchorView!)
        }
    }

    private func getRCTView(tag: NSNumber) -> McemojiPickerView {
        return bridge.uiManager.view(forReactTag: tag) as! McemojiPickerView
    }
}

class McemojiPickerView : UIView {
    @objc var onSelect: RCTDirectEventBlock?
    @objc var onClose: RCTDirectEventBlock?

    @objc var viewController: McemojiPickerViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public final func didSetProps(_ changedProps: [String]!) {
        if changedProps.contains { $0 == "onSelect"} {
            viewController.onSelect = onSelect
        }

        if changedProps.contains { $0 == "onClose"} {
            viewController.onClose = onClose
        }
    }
}

class McemojiPickerViewController : UIViewController {
    var onSelect: RCTDirectEventBlock?
    var onClose: RCTDirectEventBlock?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func open(view: UIView) {
        let mce = MCEmojiPickerViewController();
        mce.sourceView = view
        mce.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(onCloseCallback), name: .MCEmojiPickerDidDisappear, object: nil)

        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(mce, animated: false, completion: nil)
        }
    }

    @objc func onCloseCallback() {
        NotificationCenter.default.removeObserver(self, name: .MCEmojiPickerDidDisappear, object: nil)
        if onClose == nil {
            return
        }
        self.onClose!(nil);

    }
}

extension McemojiPickerViewController: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        if onSelect == nil {
            return
        }

        onSelect!(NSDictionary(dictionary: [
            "emoji": emoji
        ]) as! [AnyHashable : Any])
    }
}
