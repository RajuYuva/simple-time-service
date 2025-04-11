const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  const timestamp = new Date().toISOString();
  const ip = req.ip;
  res.json({ timestamp, ip });
});

app.listen(port, () => {
  console.log(`SimpleTimeService listening at http://localhost:${port}`);
});
