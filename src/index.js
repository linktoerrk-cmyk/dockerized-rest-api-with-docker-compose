const express = require('express');

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

// In-memory store
let todos = [];
let nextId = 1;

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', uptime: process.uptime() });
});

// List all todos
app.get('/todos', (req, res) => {
  res.json(todos);
});

// Create a todo
app.post('/todos', (req, res) => {
  const { title } = req.body;
  if (!title || typeof title !== 'string' || title.trim() === '') {
    return res.status(400).json({ error: 'title is required and must be a non-empty string' });
  }
  const todo = { id: nextId++, title: title.trim(), done: false, createdAt: new Date().toISOString() };
  todos.push(todo);
  res.status(201).json(todo);
});

// Get a single todo
app.get('/todos/:id', (req, res) => {
  const todo = todos.find(t => t.id === parseInt(req.params.id, 10));
  if (!todo) return res.status(404).json({ error: 'Todo not found' });
  res.json(todo);
});

// Delete a todo
app.delete('/todos/:id', (req, res) => {
  const index = todos.findIndex(t => t.id === parseInt(req.params.id, 10));
  if (index === -1) return res.status(404).json({ error: 'Todo not found' });
  const deleted = todos.splice(index, 1)[0];
  res.json({ message: 'Deleted', todo: deleted });
});

app.listen(PORT, () => {
  console.log(`API listening on port ${PORT}`);
});