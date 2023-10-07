import * as React from 'react';
import { useRef, useState } from 'react';
import { StyleSheet, View, Button, Text } from 'react-native';
import { EmojiPicker } from 'react-native-mcemoji-picker';

export default function App() {
  const anchorRef = useRef<any>();
  const [emoji, setEmoji] = useState('none');
  const [isPickerShow, setIsPickerShow] = useState(false);

  const [isMounted, setIsMounted] = useState(true);

  return (
    <View style={styles.container}>
      <Text style={{ fontSize: 16 }}>Selected emoji: {emoji}</Text>
      <Button
        title="Select"
        ref={anchorRef}
        onPress={() => {
          setIsPickerShow(true);
        }}
      />

      {isMounted && (
        <EmojiPicker
          anchorRef={anchorRef}
          show={isPickerShow}
          onSelect={(emoji) => {
            setEmoji(emoji);
          }}
          onClose={() => {
            setIsPickerShow(false);
          }}
        />
      )}

      <Button
        title={`${isMounted ? 'Unmount' : 'Mount'} picker(memory test)`}
        onPress={() => {
          setIsMounted((p) => !p);
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
