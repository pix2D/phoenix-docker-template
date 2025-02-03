#!/bin/sh
set -e

# Wait for Postgres to become available
while ! pg_isready -q -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER
do
  echo "Waiting for database..."
  sleep 2
done

# First time setup
if [ ! -d "/app/deps" ]; then
  echo "Running first time setup..."
  mix local.hex --force
  mix local.rebar --force
  mix deps.get
  mix deps.compile
  
  # Setup database configuration
  if [ -f "/app/config/dev.exs" ]; then
    sed -i 's/username: "postgres"/username: System.get_env("POSTGRES_USER", "postgres")/g' /app/config/dev.exs
    sed -i 's/password: "postgres"/password: System.get_env("POSTGRES_PASSWORD", "postgres")/g' /app/config/dev.exs
    sed -i 's/hostname: "localhost"/hostname: System.get_env("POSTGRES_HOST", "localhost")/g' /app/config/dev.exs
    sed -i 's/database: ".*_dev"/database: System.get_env("POSTGRES_DB", "db")/g' /app/config/dev.exs
    sed -i 's/ip: {127, 0, 0, 1}/ip: {0, 0, 0, 0}/g' /app/config/dev.exs
  fi

  # Install Node.js dependencies and compile assets
  if [ -f "/app/assets/package.json" ]; then
    echo "Installing npm dependencies..."
    cd assets && npm install && cd ..
    echo "Running asset deployment..."
    mix assets.deploy
  fi
fi

# Always try to create and migrate database
echo "Setting up database..."
mix ecto.create || true  # The '|| true' prevents failure if DB exists
mix ecto.migrate

echo "Starting Phoenix server..."
exec mix phx.server
