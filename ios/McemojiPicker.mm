#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(McemojiPickerViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onSelect, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onClose, RCTDirectEventBlock)

RCT_EXTERN_METHOD(open
                  : (nonnull NSNumber*)tag
                  forAnchor: (nonnull NSNumber*)anchor);
@end
