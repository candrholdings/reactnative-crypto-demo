# Step 5: Add an UI form

We are going to add an UI form to input text and secret.

1. Use `bluebird` package
  1. At project root, type `npm install bluebird --save`
  2. Open `index.ios.js`, add the following to the file
     ```js
     import Promise from 'bluebird';

     const
       encrypt = Promise.promisify(CryptoProvider.encrypt, { context: CryptoProvider }),
       decrypt = Promise.promisify(CryptoProvider.decrypt, { context: CryptoProvider });
     ```

2. Add an UI form
  1. Set initial state
     ```js
     constructor(props) {
       super(props);

       this.state = {
         inputString: 'Hello',
         secret: '1234567890123456',
         cipherText: '',
         plainText: ''
       };
     }
     ```

  2. Add a function to perform encryption and decryption
     ```js
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
     ```

  3. Run the encryption function on start
     ```js
     componentWillMount() {
       this._encrypt(this.state.inputStirng, this.state.encryptionKey);
     }
     ```

  4. Add a UI form
    1. Import `TextInput` component
       ```
       import {
         TextInput
       } from 'react-native';
       ```

    2. Add UI components
       ```
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
       ```

    2. Add styles
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

    3. Hook up with JavaScript logics
       ```
       onSecretChange(secret) {
         this.setState({ secret });
         this._encrypt(this.state.inputText, secret);
       }

       onInputStringChange(inputString) {
         this.setState({ inputString });
         this._encrypt(inputString, this.state.secret);
       }
       ```