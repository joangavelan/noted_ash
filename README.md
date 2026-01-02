# Noted (Ash/React version)

This is a multi-tenant notes application built with the Ash Framework, Phoenix, React, and Inertia, featuring OAuth2 authentication via Google, email/password authentication, real-time updates with Phoenix Channels, and multi-tenancy using foreign keys.

https://github.com/user-attachments/assets/7e631bac-55e6-4ce1-8044-f80f113e284e

## Features

- **Authentication**: Supports email/password authentication and OAuth2 via Google using the Ash Authentication library.
- **Multi-Tenancy**: Uses foreign keys to isolate tenant data securely.
- **RBAC (Role-Based Access Control)**: Provides authorization for different user roles.
- **Real-Time Updates:** Instant updates across workspace members using Phoenix Channels.
- **Modern Frontend**: Built with React and Inertia.js for a seamless single-page application experience.
- **Notes Management**: Create, edit, delete, and organize notes within a tenant.

## Entity-Relationship Diagram (ERD)

![noted_ash_erd](https://github.com/user-attachments/assets/5bf68a72-80d4-4dc9-9f5a-bf06ac39303b)

## Prerequisites

Before setting up the application, ensure you have the following installed:

- **Elixir**: Version 1.14 or later. [Installation Guide](https://elixir-lang.org/install.html)
- **Erlang**: Version 24 or later. [Installation Guide](https://elixir-lang.org/install.html)
- **Node.js**: Version 16 or later. [Installation Guide](https://nodejs.org/)
- **PostgreSQL**: Ensure it's installed and running. [Installation Guide](https://www.postgresql.org/download/)

## Setup Instructions

### Clone the Repository

```bash
git clone https://github.com/joangavelan/noted_ash.git
cd noted_ash
```

### Install Dependencies

Fetch and install the necessary Elixir dependencies:

```bash
mix deps.get
```

Install Node.js dependencies for the frontend:

```bash
cd assets
npm install
cd ..
```

### Database

```shell
$ docker pull postgres:17-bookworm

$ docker volume create pgdata_noted_ash
$ docker volume inspect pgdata_noted_ash

$ docker run --name psql_noted_ash -p 5481:5432 \
-e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres \
-v pgdata_noted_ash:/var/lib/postgresql/data \
-d postgres:17-bookworm
```

### Configure Environment Variables

The application requires environment variables for Google OAuth2 authentication. Create a file named `.env` in the project root and add the following variables:

```bash
export GOOGLE_CLIENT_ID=your_google_client_id
export GOOGLE_CLIENT_SECRET=your_google_client_secret
export GOOGLE_REDIRECT_URI=your_google_redirect_uri
```

Replace `your_google_client_id` and `your_google_client_secret` with your actual Google OAuth2 credentials, and `your_google_redirect_uri` with your application's redirect URI.

**Note:** The `GOOGLE_REDIRECT_URI` should match the redirect URI configured in your Google Console OAuth2 settings.

### Database Configuration

Configure your database settings in `config/dev.exs`. Ensure the `username`, `password`, `hostname`, and `database` fields match your PostgreSQL setup:

```elixir
config :noted, Noted.Repo,
  username: "your_db_username",
  password: "your_db_password",
  hostname: "localhost",
  database: "noted_dev",
```

### Upgrade to be OTP 28 and above compatible

```shell
mix deps.update inflex # will only work after editing the `mix.exs` file
mix deps.compile inflex --force
mix deps.update igniter
mix deps.compile igniter --force
mix deps.update ash_postgres
mix deps.compile ash_postgres --force


mix deps.update ash_authentication_phoenix
mix deps.update ash_authentication
mix deps.update ash_postgres
mix deps.update ash_phoenix
mix deps.get
mix deps.compile
```

### Create and Migrate the Database

Set up the database by running:

```bash
mix ecto.create
mix ecto.migrate
```

### Start the Server

Start the Phoenix server while loading the `.env` file:

```shell
source .env && iex -S mix phx.server
```

Validate if loading all env variables is OK

```shell
Application.get_env(:noted, :google_client_id)
Application.get_env(:noted, :google_client_secret)
Application.get_env(:noted, :google_redirect_uri)
```

The `source .env` command ensures your environment variables are loaded, and `mix phx.server` starts the application. The app will be accessible at [http://localhost:4000](http://localhost:4000).

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request with improvements or feedback.

---
