
```bash
#!/bin/bash

# Project Name
PROJECT_NAME="my-microservices-app"

# Create the main project directory
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Create microservices directories
mkdir -p services/{auth,users,products,orders}

# Create shared directories
mkdir -p shared/{utils,middlewares,config}

# Initialize a new Node.js project
npm init -y

# Create basic structure and files for each service
for SERVICE in auth users products orders; do
    cd services/$SERVICE
    npm init -y
    echo "const express = require('express');" > index.js
    echo "const app = express();" >> index.js
    echo "const PORT = process.env.PORT || 3000;" >> index.js
    echo "" >> index.js
    echo "app.listen(PORT, () => {" >> index.js
    echo "    console.log('Server is running on port ' + PORT);" >> index.js
    echo "});" >> index.js
    cd ../..
done

# Create a README file
echo "# $PROJECT_NAME" > README.md
echo "This is a microservices architecture project using Node.js." >> README.md

# Create a .gitignore file
echo "node_modules/" > .gitignore

# Output completion message
echo "Node.js microservices project structure created successfully."

```

### How to Use the Script

1. **Create the Script File**:
   Save the script above in a file named `index.sh`.

2. **Make the Script Executable**:
   Open your terminal, navigate to the directory where `index.sh` is saved, and run:
   ```bash
   chmod +x index.sh
   ```

3. **Run the Script**:
   Execute the script by running:
   ```bash
   ./index.sh
   ```

