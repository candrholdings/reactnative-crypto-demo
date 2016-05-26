# Step 1: Adds UI components

## Objectives

We are going to laydown our plan for the UI. We will add a few textboxes:

* Input string
* Secret
* Ciphertext
  * Read-only
* Plaintext (decrypted from ciphertext)
  * Read-only

## Steps to achieve

1. Adds textboxes to the user interface
  1. Before we can use `TextInput` component from React Native, we will need to import it from `react-native` package

    ```javascript
    import {
      TextInput
    } from 'react-native';
    ```

  2. Adds a title and textboxes to the app
    1. Textboxes will display values from `this.state`
    2. Change events from input string and secret textboxes will go back to `this.state`
    3. Styles the UI components

      ```javascript
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

  3. Adds styles to the stylesheet variable `styles`

    ```javascript
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
    1. Sync the changes from input string and secret textboxes to `this.state`
    2. If the `onChangeText` is not processed, the textbox will become read-only because `render` will keep using the old text from `this.state`

      ```javascript
      onInputStringChange(inputString) {
        this.setState({ inputString });
      }

      onSecretChange(secret) {
        this.setState({ secret });
      }
      ```

  5. Defines default values in constructor
    1. Default input string is `Hello`
    2. Default secret is `1234567890123456` (we will use AES128, thus 16 characters long secret will be used)

    ```javascript
    constructor(props) {
      super(props);

      this.state = {
        inputString: 'Hello',
        secret: '1234567890123456'
      };
    }
    ```

## What's next

Go to the [next step](https://github.com/candrholdings/reactnative-crypto-demo/tree/step-2).