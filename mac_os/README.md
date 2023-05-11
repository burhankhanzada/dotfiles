# MacOS

## Defaults

1. Get all Domains

    ```sh
    defualts domains
    ```

2. Read All keys and values of a domain

    ```sh
    defaults read <domain>
    ```

3. Show the value type of the given key of domain

    ```sh
    read-type <domain> <key>
    ```

4. Observer value change
  
    ```sh
    defaults read > before.json

    # make chnages from GUI

    defaults read > after.json

    code --diff before.json after.json
    ```

## NVRAM

1. Read all NVRAM variables

    ```sh
    nvram -xp
    ```

2. Read single varaible

    ```sh
    nvram -x <varaible_name>
    ```

3. Observe value change

    ```sh
    nvram -x -p > before.xml

    # make chnages from GUI

    nvram -x -p > after.xml
    
    code --diff before.xml after.xml
    ```
