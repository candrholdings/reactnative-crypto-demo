# Step 5: Adds an UI form

We are going to add an UI form to input text and secret.

1. Adds an UI form by modifying `index.ios.js`
  1. Boots up the code by providing some initial values

    ```js
    constructor(props) {
      super(props);

      this.state = {
        inputString: 'Hello',
        secret: '1234567890123456'
      };
    }
    ```

  2. Adds a helper function to encrypt and decrypt the text, returns the result as state in React
    1. We implement it in Promise fashion to simplify the code

    ```js
    _encrypt(inputString, secret) {
      return CryptoProvider.encrypt(inputString, secret)
        .then(ciphertext => {
          this.setState({ ciphertext });

          return CryptoProvider.decrypt(ciphertext, secret);
        })
        .then(plaintext => {
          this.setState({ plaintext });
        });
    }
    ```

  3. When the app is getting loaded, we will boot the encryption immediately

    ```js
    componentWillMount() {
      this._encrypt(this.state.inputStirng, this.state.encryptionKey).done();
    }
    ```

  4. Adds UI components
    1. Before we can use `TextInput` component from React Native, we will need to import it from `react-native`

      ```js
      import {
        TextInput
      } from 'react-native';
      ```

    2. Adds UI components to the page

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

    2. Styles the new UI components

      ```js
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
      ```

    3. Hooks up with JavaScript
      1. When either the input string or secret textbox is updated, we will rerun the encryption process

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
