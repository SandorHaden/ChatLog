// ChatLog Version Checker
// Checks for updates from GitHub and returns update information

const https = require('https');
const fs = require('fs');
const path = require('path');

// Get current version from VERSION.txt
function getCurrentVersion() {
  try {
    const versionPath = path.join(__dirname, 'assets', 'VERSION.txt');
    return fs.readFileSync(versionPath, 'utf8').trim();
  } catch (error) {
    console.log('Current version file not found, assuming version 1.0.0');
    return '1.0.0';
  }
}

// Get latest version from GitHub
function getLatestVersion() {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'raw.githubusercontent.com',
      port: 443,
      path: '/SandorHaden/ChatLog/master/assets/VERSION.txt',
      method: 'GET'
    };

    const req = https.get(options, (res) => {
      let data = '';
      
      res.on('data', (chunk) => {
        data += chunk;
      });
      
      res.on('end', () => {
        resolve(data.trim());
      });
    });

    req.on('error', (error) => {
      reject(error);
    });
    
    req.end();
  });
}

// Compare versions (simple string comparison for now)
function isUpdateAvailable(current, latest) {
  return latest > current;
}

// Main function
async function checkForUpdates() {
  try {
    const currentVersion = getCurrentVersion();
    const latestVersion = await getLatestVersion();
    
    console.log(`Current version: ${currentVersion}`);
    console{"message":"Operation not allowed"}