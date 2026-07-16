.PHONY: build run up down logs test clean

# Build the Docker image via docker-compose
build:
	docker-compose build

# Start in foreground
run:
	docker-compose up --build

# Start detached (background)
up:
	docker-compose up --build -d

# Stop and remove containers
down:
	docker-compose down

# Tail container logs
logs:
	docker-compose logs -f api

# Remove containers, images, and volumes built by compose
clean:
	docker-compose down --rmi local --volumes --remove-orphans

# Smoke-test the running API (requires the container to be up)
test:
	@echo "--- Health check ---"
	@curl -sf http://localhost:3000/health | python3 -m json.tool || (echo "FAIL: /health" && exit 1)
	@echo "--- Create todo ---"
	@curl -sf -X POST http://localhost:3000/todos \
		-H "Content-Type: application/json" \
		-d '{"title":"Test todo"}' | python3 -m json.tool || (echo "FAIL: POST /todos" && exit 1)
	@echo "--- List todos ---"
	@curl -sf http://localhost:3000/todos | python3 -m json.tool || (echo "FAIL: GET /todos" && exit 1)
	@echo "--- Get todo by ID ---"
	@curl -sf http://localhost:3000/todos/1 | python3 -m json.tool || (echo "FAIL: GET /todos/1" && exit 1)
	@echo "--- Delete todo ---"
	@curl -sf -X DELETE http://localhost:3000/todos/1 | python3 -m json.tool || (echo "FAIL: DELETE /todos/1" && exit 1)
	@echo "--- All tests passed! ---"