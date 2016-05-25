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

import Promise from 'bluebird';

const
  encrypt = Promise.promisify(CryptoProvider.encrypt, { context: CryptoProvider }),
  decrypt = Promise.promisify(CryptoProvider.decrypt, { context: CryptoProvider });

class EncryptNatively extends Component {
  constructor(props) {
    super(props);

    this.state = {
      inputString: 'Hello',
      secret: '1234567890123456'
    };
  }

  _encrypt(inputString, secret) {
    encrypt(inputString, secret)
      .then(cipherText => {
        this.setState({ cipherText });

        return decrypt(cipherText, secret);
      })
      .then(plainText => {
        this.setState({ plainText });
      })
  }

  componentWillMount() {
    this._encrypt(this.state.inputString, this.state.secret);
  }

  onSecretChange(secret) {
    this.setState({ secret });
    this._encrypt(this.state.inputString, secret);
  }

  onInputStringChange(inputString) {
    this.setState({ inputString });
    this._encrypt(inputString, this.state.secret);
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
        <Text style={ styles.welcome }>
          Encrypt with AES128
        </Text>
        <Text style={ styles.labels }>Input plain text</Text>
        <TextInput
          autoFocus={ true }
          onChangeText={ this.onInputStringChange.bind(this) }
          style={ styles.inputs }
          value={ this.state.inputString }
        />
        <Text style={ styles.labels }>Encryption key (16 characters)</Text>
        <TextInput
          onChangeText={ this.onSecretChange.bind(this) }
          style={ styles.inputs }
          value={ this.state.secret }
        />
        <Text style={ styles.labels }>Cipher text in BASE64</Text>
        <TextInput
          editable={ false }
          style={ styles.inputs }
          value={ this.state.cipherText }
        />
        <Text style={ styles.labels }>Plain text</Text>
        <TextInput
          editable={ false }
          style={ styles.inputs }
          value={ this.state.plainText }
        />
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
