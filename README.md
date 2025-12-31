# Travel Agency Databases

This project sets up two separate databases (PostgreSQL and MySQL) for a travel agency application using Docker Compose.

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1.  Start the databases:
    ```bash
    docker-compose up -d
    ```

2.  Stop the databases:
    ```bash
    docker-compose down
    ```

## Database Details

### PostgreSQL
- **Host**: localhost
- **Port**: 5432
- **Database**: `travel_db`
- **User**: `myuser`
- **Password**: `mypassword`
- **Container Name**: `travel_postgres`

### MySQL
- **Host**: localhost
- **Port**: 3306
- **Database**: `travel_db`
- **User**: `myuser`
- **Password**: `mypassword`
- **Root Password**: `rootpassword`
- **Container Name**: `travel_mysql`

## Schema

Both databases are initialized with the following tables:
- `trip`: Stores trip information (destination, dates, price, etc.).
- `traveler`: Stores traveler information (name, email, passport, etc.).
- `booking`: Links travelers to trips.

Sample data is automatically inserted on startup.
