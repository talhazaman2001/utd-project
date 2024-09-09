const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Dummy Manchester United News
const news = [
  { id: 1, title: 'Manchester United beats Arsenal', content: 'Manchester United wins 3-1 against Arsenal...' },
  { id: 2, title: 'Bruno Fernandes Scores Hat-trick', content: 'Bruno Fernandes leads Manchester United to a 4-0 win...' },
];

// Define routes
app.get('/', (req, res) => {
  res.send('<h1>Welcome to Manchester United Football News Blog</h1>');
});

app.get('/news', (req, res) => {
  res.json(news);
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
