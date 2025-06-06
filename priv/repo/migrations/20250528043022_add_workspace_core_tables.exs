defmodule Noted.Repo.Migrations.AddWorkspaceCoreTables do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:teams, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v7()"), primary_key: true
      add :name, :text, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create table(:team_members, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v7()"), primary_key: true

      add :user_id,
          references(:users,
            column: :id,
            name: "team_members_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :team_id,
          references(:teams,
            column: :id,
            name: "team_members_team_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :role, :text, null: false
    end

    create table(:roles, primary_key: false) do
      add :name, :text, null: false, primary_key: true
    end

    alter table(:team_members) do
      modify :role,
             references(:roles,
               column: :name,
               name: "team_members_role_fkey",
               type: :text,
               prefix: "public"
             )
    end

    create unique_index(:team_members, [:team_id, :user_id, :team_id],
             name: "team_members_unique_user_membership_index"
           )

    create table(:invitations, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v7()"), primary_key: true

      add :invited_user_id,
          references(:users,
            column: :id,
            name: "invitations_invited_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :inviter_user_id,
          references(:users,
            column: :id,
            name: "invitations_inviter_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :team_id,
          references(:teams,
            column: :id,
            name: "invitations_team_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false
    end

    create index(:invitations, [:team_id])

    create unique_index(:invitations, [:team_id, :invited_user_id, :team_id],
             name: "invitations_unique_user_invitation_index"
           )
  end

  def down do
    drop_if_exists unique_index(:invitations, [:team_id, :invited_user_id, :team_id],
                     name: "invitations_unique_user_invitation_index"
                   )

    drop_if_exists index(:invitations, [:team_id])

    drop constraint(:invitations, "invitations_invited_user_id_fkey")

    drop constraint(:invitations, "invitations_inviter_user_id_fkey")

    drop constraint(:invitations, "invitations_team_id_fkey")

    drop table(:invitations)

    drop_if_exists unique_index(:team_members, [:team_id, :user_id, :team_id],
                     name: "team_members_unique_user_membership_index"
                   )

    drop constraint(:team_members, "team_members_role_fkey")

    alter table(:team_members) do
      modify :role, :text
    end

    drop table(:roles)

    drop constraint(:team_members, "team_members_user_id_fkey")

    drop constraint(:team_members, "team_members_team_id_fkey")

    drop table(:team_members)

    drop table(:teams)
  end
end
