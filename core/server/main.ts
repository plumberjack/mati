import express from 'express';

const app = express();

app.get('/', (req, res) => {
  res.send('henlo');
});

const server = app.listen(1984);
