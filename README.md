# Phoenix Docker Development Template

This template provides a streamlined development setup for Phoenix projects using Docker, eliminating the need to install Elixir, Phoenix, or PostgreSQL locally.

Standard tools are used to generate a new Phoenix project (through a throwaway docker container). Then a light-weight docker-compose setup is copied into the project. This allows both generation of new projects, and ongoing development, purely through Docker with no local dependencies.

## Features

- Complete Docker-based development environment
- PostgreSQL database setup and configuration
- Automatic environment configuration
- Hot code reloading
- Asset compilation (when needed)
- Database migration handling

## Prerequisites

- Docker
- Docker Compose

No other dependencies required - everything runs in containers!

## Creating a New Project

1. Clone this template:
```bash
git clone git@github.com:pix2D/phoenix-docker-template.git
```

2. Create a new project:
```bash
cd phoenix-docker-template
./phx_new_docker.sh your_project_name
```

This will create your project in the parent directory.

3. Start the development environment:
```bash
cd ../your_project_name
docker compose up -d
```

Note: it will take a while for the initial setup to finish. You can monitor the progress using `docker compose logs -f`.

## Docker Commands

### Container Management
```bash
# Start containers in background
docker compose up -d

# View logs
docker compose logs

# Follow logs
docker compose logs -f

# Stop containers
docker compose down

# Rebuild containers
docker compose up -d --build
```

### Executing Commands in Container
```bash
# Run mix commands
docker compose exec web mix help
docker compose exec web mix test

# Run shell in container
docker compose exec web sh

# Run iex in container
docker compose exec web iex

# Run Phoenix commands
docker compose exec web mix phx.routes
```

## Project Structure

The template sets up a standard Phoenix project with some Docker-specific additions:

```
your_project/
├── docker/
│   ├── Dockerfile.dev      # Development Dockerfile
│   └── entrypoint.sh       # Container startup script
├── docker-compose.yml      # Docker Compose configuration
├── .dockerignore           # Docker ignore file
└── ... (standard Phoenix files)
```

## Common Development Tasks

### Adding NPM Dependencies
If you need to add Node.js dependencies:

1. Create `assets/package.json` if it doesn't exist
2. Add dependencies to package.json
3. Rebuild the container: `docker compose up -d --build`

### Database Management
The PostgreSQL database persists data in a Docker volume. To reset completely:

```bash
docker compose down -v # -v removes volumes
docker compose up -d   # Recreates everything from scratch
```

### Accessing PostgreSQL
To access the database directly:

```bash
docker compose exec db psql -U postgres
```

## Troubleshooting

### Container Won't Start
Check the logs:
```bash
docker compose logs
```

### Database Connection Issues
1. Ensure the database container is running:
```bash
docker compose ps
```

2. Check database logs:
```bash
docker compose logs db
```

### Asset Compilation Issues
1. Access the container:
```bash
docker compose exec web sh
```

2. Check the assets directory:
```bash
cd assets
npm install
```

## Contributing

This template is mainly made for personal use, but feel free to submit an issue if you run into a problem or have a suggestion and I'll consider it.
