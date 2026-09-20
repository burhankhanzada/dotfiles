# macOS
 
## Defaults
 
1. Get all Domains
 
    ```sh
    defaults domains
    ```
 
2. Read All keys and values of a domain
 
    ```sh
    defaults read <domain>
    ```
 
3. Show the value type of the given key of domain
 
    ```sh
    defaults read-type <domain> <key>
    ```
 
4. Observe value change
   
    ```sh
    defaults read > before.json
 
    # make changes from GUI
 
    defaults read > after.json
 
    code --diff before.json after.json
    ```
 
## NVRAM
 
1. Read all NVRAM variables
 
    ```sh
    nvram -xp
    ```
 
2. Read single variable
 
    ```sh
    nvram -x <variable_name>
    ```
 
3. Observe value change
 
    ```sh
    nvram -x -p > before.xml
 
    # make changes from GUI
 
    nvram -x -p > after.xml
     
    code --diff before.xml after.xml
    ```
