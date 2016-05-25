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

import Promise from 'bluebird';

var {
  CryptoProvider
} = require('NativeModules');

const ENCRYPTION_KEY = 'P@ssw0rdP@ssw0rd';

const
  encrypt = Promise.promisify(CryptoProvider.encrypt, { context: CryptoProvider }),
  decrypt = Promise.promisify(CryptoProvider.decrypt, { context: CryptoProvider });

class EncryptNatively extends Component {
  constructor(props) {
    super(props);

    this.state = {
      encryptionKey: ENCRYPTION_KEY,
      inputText: 'Hello, World!',
      cipherText: null,
      decipherText: null
    };
  }

  componentWillMount() {
    this._encrypt(this.state.encryptionKey, this.state.inputText);
  }

  onEncryptionKeyChange(encryptionKey) {
    this.setState({ encryptionKey });
    this._encrypt(encryptionKey, this.state.inputText);
  }

  onInputTextChange(inputText) {
    this.setState({ inputText });
    this._encrypt(this.state.encryptionKey, inputText);
  }

  _encrypt(encryptionKey, inputText) {
    encrypt(encryptionKey, inputText)
      .then(cipherText => {
        this.setState({ cipherText });

        return decrypt(encryptionKey, cipherText);
      })
      .then(decipherText => {
        this.setState({ decipherText: decipherText });
      })
  }

  render() {
    const { state } = this;

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
        <Text style={ styles.welcome }>
          Encrypt with AES128
        </Text>
        <Text style={ styles.labels }>Encryption key (16 characters)</Text>
        <TextInput onChangeText={ this.onEncryptionKeyChange.bind(this) } style={ styles.inputs } value={ state.encryptionKey } />
        <Text style={ styles.labels }>Input plain text</Text>
        <TextInput onChangeText={ this.onInputTextChange.bind(this) } style={ styles.inputs } value={ state.inputText } />
        <Text style={ styles.labels }>Cipher text in BASE64</Text>
        <TextInput style={ styles.inputs } value={ state.cipherText } />
        <Text style={ styles.labels }>Decrypted cipher text</Text>
        <TextInput style={ styles.inputs } value={ state.decipherText } />
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
  },
  labels: {
    textAlign: 'center',
    color: '#333',
    marginBottom: 5,
  },
  inputs: {
    backgroundColor: '#FFF',
    borderColor: '#333',
    borderRadius: 5,
    borderWidth: 1,
    height: 40,
    textAlign: 'center',
    marginBottom: 5
  }
});

AppRegistry.registerComponent('EncryptNatively', () => EncryptNatively);
