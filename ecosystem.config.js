module.exports = {
  apps: [{
    name: 'avaroom',
    script: 'src/app.js',
    instances: 2,
    exec_mode: 'cluster',
    autorestart: true,
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    }
  }]
};
