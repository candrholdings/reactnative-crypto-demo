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
  View
} from 'react-native';

import {
  TextInput
} from 'react-native';

class EncryptNatively extends Component {
  constructor(props) {
    super(props);

    this.state = {
      inputString: 'Hello',
      secret: '1234567890123456'
    };
  }

  onSecretChange(secret) {
    this.setState({ secret });
  }

  onInputStringChange(inputString) {
    this.setState({ inputString });
  }

  render() {
    return (
      <Text style={ styles.welcome }>
        Encrypt with AES128
      </Text>
      <Text style={ styles.labels }>Input plaintext</Text>
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
      <Text style={ styles.labels }>Ciphertext in BASE64</Text>
      <TextInput
        editable={ false }
        style={ styles.inputs }
        value={ this.state.ciphertext }
      />
      <Text style={ styles.labels }>Plaintext</Text>
      <TextInput
        editable={ false }
        style={ styles.inputs }
        value={ this.state.plaintext }
      />
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
  },
  labels: {
    textAlign: 'center',
    color: '#333',
    marginBottom: 5
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
