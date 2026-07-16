# Dockerized REST API

A simple Node.js REST API containerized with Docker and orchestrated with docker-compose. Includes a `/health` endpoint, basic CRUD routes for a todo list, a Docker healthcheck, and a Makefile for common development commands.

## Tech Stack

- **Node.js** + **Express** — REST API
- **Docker** — containerization
- **docker-compose** — orchestration
- **Makefile** — build/test/run automation

## Project Structure

```
.
├── docker-compose.yml
├── Dockerfile
├── Makefile
├── README.md
└── src/
    └── index.js
```

## Getting Started

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (v20+)
- [docker-compose](https://docs.docker.com/compose/install/) (v2+)
- `make` (usually pre-installed on Linux/macOS; Windows users can use Git Bash or WSL)

### Run with Make

```bash
# Build the Docker image
make build

# Start the API (runs in foreground)
make run

# Start detached (background)
make up

# Stop containers
make down

# Run tests (curl-based smoke tests)
make test

# View logs
make logs
```

### Run manually with docker-compose

```bash
docker-compose up --build
```

The API will be available at **http://localhost:3000**.

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check — returns `{ status: "ok" }` |
| GET | `/todos` | List all todos |
| POST | `/todos` | Create a new todo |
| GET | `/todos/:id` | Get a todo by ID |
| DELETE | `/todos/:id` | Delete a todo by ID |

### Example Requests

```bash
# Health check
curl http://localhost:3000/health

# Create a todo
curl -s -X POST http://localhost:3000/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Docker"}'

# List all todos
curl http://localhost:3000/todos
```

## Docker Healthcheck

The container includes a Docker-native healthcheck that polls `/health` every 30 seconds. You can inspect it with:

```bash
docker inspect --format='{{json .State.Health}}' dockerized-api
```

## Notes

- Data is stored **in-memory** — it resets when the container restarts. This keeps the project simple and dependency-free.
- To add persistence, swap the in-memory array for a database like PostgreSQL or MongoDB and add it as a second service in `docker-compose.yml`.