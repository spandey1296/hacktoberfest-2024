#!/bin/bash

# Log message function
log_message() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1"
}

# Create project directory
log_message "Creating project directory..."
mkdir resume-upload-app
cd resume-upload-app || exit
log_message "Project directory created."

# Create environment variables file
log_message "Creating .env file..."
cat <<EOL > .env
AWS_ACCESS_KEY_ID=your_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
AWS_REGION=your_aws_region
S3_BUCKET_NAME=your_s3_bucket_name
PORT=3000
EOL
log_message ".env file created."

# Create index.js file
log_message "Creating index.js file..."
cat <<EOL > index.js
const express = require('express');
const multer = require('multer');
const path = require('path');
const bodyParser = require('body-parser');
const uploadFile = require('./upload');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
    }
});

const fileFilter = (req, file, cb) => {
    const filetypes = /pdf|doc|docx/;
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = filetypes.test(file.mimetype);

    if (mimetype && extname) {
        return cb(null, true);
    } else {
        cb('Error: Only PDF and DOC files are allowed!');
    }
};

const upload = multer({
    storage: storage,
    limits: { fileSize: 1024 * 1024 * 5 }, // 5 MB limit
    fileFilter: fileFilter
}).single('resume');

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.post('/submit', (req, res) => {
    upload(req, res, async (err) => {
        if (err) {
            return res.status(400).send(err);
        }

        if (!req.file) {
            return res.status(400).send('No file uploaded');
        }

        try {
            const s3Response = await uploadFile(req.file);
            console.log(s3Response);

            res.send('File uploaded successfully to ' + s3Response.Location);
        } catch (err) {
            console.error(err);
            res.status(500).send('Error uploading file');
        }
    });
});

app.listen(port, () => {
    console.log(\`Server is running on port \${port}\`);
});
EOL
log_message "index.js file created."

# Create upload.js file
log_message "Creating upload.js file..."
cat <<EOL > upload.js
const AWS = require('aws-sdk');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const s3 = new AWS.S3({
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    region: process.env.AWS_REGION
});

const uploadFile = (file) => {
    const fileContent = fs.readFileSync(file.path);

    const params = {
        Bucket: process.env.S3_BUCKET_NAME,
        Key: \`resumes/\${file.originalname}\`,
        Body: fileContent,
        ContentType: file.mimetype
    };

    return s3.upload(params).promise();
};

module.exports = uploadFile;
EOL
log_message "upload.js file created."

# Create public directory and HTML/CSS files
log_message "Creating public directory and files..."
mkdir -p public

cat <<EOL > public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resume Upload Portal</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h2>Upload Your Resume</h2>
        <form action="/submit" method="POST" enctype="multipart/form-data">
            <label for="firstname">First Name:</label>
            <input type="text" id="firstname" name="firstname" required><br>

            <label for="lastname">Last Name:</label>
            <input type="text" id="lastname" name="lastname" required><br>

            <label for="email">Email ID:</label>
            <input type="email" id="email" name="email" required><br>

            <label for="phone">Phone Number:</label>
            <input type="text" id="phone" name="phone" required><br>

            <label for="country">Country:</label>
            <input type="text" id="country" name="country" required><br>

            <label for="resume">Upload Resume:</label>
            <input type="file" id="resume" name="resume" accept=".pdf,.doc,.docx" required><br>

            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
EOL

cat <<EOL > public/styles.css
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}

.container {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h2 {
    margin-bottom: 20px;
}

label {
    display: block;
    margin: 10px 0 5px;
}

input[type="text"],
input[type="email"],
input[type="file"] {
    width: 100%;
    padding: 8px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

button {
    padding: 10px 15px;
    background: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

button:hover {
    background: #0056b3;
}
EOL
log_message "public directory and files created."

# Create uploads directory
log_message "Creating uploads directory..."
mkdir -p uploads
log_message "uploads directory created."

# Initialize npm project and install dependencies
log_message "Initializing npm project..."
npm init -y
log_message "npm project initialized."

log_message "Installing dependencies..."
npm install express multer aws-sdk dotenv body-parser
log_message "Dependencies installed."

log_message "Project setup complete. You can now start the server with 'node index.js'."
