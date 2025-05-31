defmodule Noted.Workspace.Role do
  use Ash.Resource,
    otp_app: :noted,
    domain: Noted.Workspace,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "roles"
    repo Noted.Repo
  end

  attributes do
    attribute :name, :string do
      primary_key? true
      allow_nil? false
      public? true
    end
  end

  relationships do
    has_many :team_members, Noted.Workspace.TeamMember do
      source_attribute :name
      destination_attribute :role
    end
  end
end
