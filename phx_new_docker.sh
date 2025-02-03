#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Usage: ./create-phoenix.sh project_name"
    exit 1
fi

PROJECT_NAME=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$PARENT_DIR/$PROJECT_NAME"

# Create new Phoenix project in parent directory
echo "Creating new Phoenix project..."
docker run --rm -v $PARENT_DIR:/app -w /app elixir:latest sh -c "mix local.hex --force && mix archive.install --force hex phx_new && mix phx.new $PROJECT_NAME"

# Copy Docker files from template to new project
echo "Setting up Docker configuration..."
cp -r "$SCRIPT_DIR/docker" "$PROJECT_DIR/"
cp "$SCRIPT_DIR/docker-compose.yml" "$PROJECT_DIR/"
cp "$SCRIPT_DIR/.dockerignore" "$PROJECT_DIR/"

echo "Project $PROJECT_NAME created successfully at $PROJECT_DIR!"
echo "cd into $PROJECT_DIR and run 'docker compose up' to start development"
