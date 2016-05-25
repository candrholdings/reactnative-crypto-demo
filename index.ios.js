/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';

import {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  View
} from 'react-native';

import {
  CryptoProvider
} from 'NativeModules';

class EncryptNatively extends Component {
  componentDidMount() {
    CryptoProvider.encrypt('Hello', '1234567890123456')
      .then(
        cipherText => {
          return CryptoProvider.decrypt(cipherText, '1234567890123456');
        },
        err => {
          alert(`Failed to encrypt: ${err.message}`);
        }
      )
      .then(
        plainText => {
          alert(`Plain text: ${plainText}`);
        },
        err => {
          alert(`Failed to decrypt: ${err.message}`);
        }
      )
      .done();
  }

  render() {
    return (
      <View style={ styles.container }>
        <Text style={ styles.welcome }>
          Welcome to React Native!
        </Text>
        <Text style={ styles.instructions }>
          To get started, edit index.ios.js
        </Text>
        <Text style={ styles.instructions }>
          Press Cmd+R to reload,{ '\n' }
          Cmd+D or shake for dev menu
        </Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    padding: 20
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333',
    marginBottom: 5,
  }
});

AppRegistry.registerComponent('EncryptNatively', () => EncryptNatively);
