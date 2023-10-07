import React, {
  useCallback,
  useRef,
  type RefObject,
  useEffect,
  type FC,
} from 'react';
import {
  requireNativeComponent,
  UIManager,
  Platform,
  findNodeHandle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-mcemoji-picker' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ComponentName = 'McemojiPickerView';

const McemojiPickerView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<EmojiPickerProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

export interface EmojiPickerProps {
  anchorRef: RefObject<any>;
  show: boolean;
  onClose: () => void;
  onSelect?: (emoji: string) => void;
}

export const EmojiPicker: FC<EmojiPickerProps> = function EmojiPicker(props) {
  const { show, anchorRef, onSelect, onClose } = props;

  const innerRef = useRef<any>();

  const onSelectFn = useCallback(
    (ev) => {
      onSelect?.(ev.nativeEvent.emoji);
    },
    [onSelect]
  );

  const open = useCallback(() => {
    const anchorTag = findNodeHandle(anchorRef.current);
    if (!anchorTag) {
      throw new Error('Cannot find the anchor node for showing emoji picker');
    }

    UIManager.dispatchViewManagerCommand(
      findNodeHandle(innerRef.current),
      UIManager.getViewManagerConfig(ComponentName).Commands.open!,
      [anchorTag]
    );
  }, []);

  useEffect(() => {
    if (show) {
      open();
    }
  }, [open, show]);

  return (
    <McemojiPickerView
      // @ts-ignore
      ref={innerRef}
      onSelect={onSelectFn}
      onClose={onClose}
    />
  );
};
