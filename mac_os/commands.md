# Commands for defaults

1. Get all Domains

    ```sh
    defualts domains
    ```

2. Commands to find settings effected by gui to know domain and key
  
    ```sh
    defaults read > before.json

    # make chnages from GUI

    defaults read > after.json

    code --diff before.json after.json
    ```

3. Read All keys and values of a domain

    ```sh
    defaults read <domain>
    ```

4. Show the value type of the given key of domain

    ```sh
    read-type <domain> <key>
    ```
