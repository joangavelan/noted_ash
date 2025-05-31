defmodule Noted.Workspace.Team do
  use Ash.Resource,
    otp_app: :noted,
    domain: Noted.Workspace,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "teams"
    repo Noted.Repo
  end

  actions do
    defaults [:read, :destroy]

    create :create_team do
      description "Creates a new Team and assigns the actor as an admin by creating a new TeamMember record in a single transaction"

      accept [:name]

      change after_action(fn _changeset, team, context ->
               team_member_attrs = %{
                 user_id: context.actor.id,
                 role: "admin"
               }

               Noted.Workspace.add_team_member!(team_member_attrs,
                 tenant: team,
                 authorize?: false
               )

               {:ok, team}
             end)
    end

    read :list_user_teams do
      description "List all teams that a user is a member of"
      filter expr(users.id == ^actor(:id))
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if expr(users.id == ^actor(:id))
      authorize_if expr(exists(invitations, invited_user_id == ^actor(:id)))
    end

    policy action(:create_team) do
      authorize_if always()
    end

    policy action_type(:destroy) do
      authorize_if expr(^actor(:role) == "admin" and exists(users, id == ^actor(:id)))
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
      constraints min_length: 2, max_length: 50
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :invitations, Noted.Workspace.Invitation

    many_to_many :users, Noted.Accounts.User do
      through Noted.Workspace.TeamMember
    end
  end

  defimpl Ash.ToTenant do
    def to_tenant(%{id: id} = tenant, _resource) when is_map(tenant), do: id
    def to_tenant(id, _resource) when is_binary(id), do: id
  end
end
