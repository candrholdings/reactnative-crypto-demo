# Step 1: Adds UI components

## Objectives

We are going to laydown our plan for the UI. We will add a few textboxes:

* Input string
* Secret
* Ciphertext
* Plaintext (decrypted from ciphertext)

## Steps to achieve

1. Adds textboxes to the user interface
  1. Before we can use `TextInput` component from React Native, we will need to import it from `react-native` package

    ```js
    import {
      TextInput
    } from 'react-native';
    ```

  2. Adds a title and textboxes to the app
    1. Hooks up the textboxes with values from `this.state`
    2. Styles the UI components

      ```js
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
      ```

  3. Adds styles classes

    ```js
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
    ```

  4. Adds behaviors to the components

    ```js
    onSecretChange(secret) {
      this.setState({ secret });
      this._encrypt(this.state.inputText, secret).done();
    }

    onInputStringChange(inputString) {
      this.setState({ inputString });
      this._encrypt(inputString, this.state.secret).done();
    }
    ```

Go to the [next step](https://github.com/candrholdings/reactnative-crypto-demo/tree/step-2).