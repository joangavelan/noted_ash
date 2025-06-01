defmodule Noted.Workspace.TeamMember do
  use Ash.Resource,
    otp_app: :noted,
    domain: Noted.Workspace,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "team_members"
    repo Noted.Repo

    references do
      reference :user, on_delete: :delete
      reference :team, on_delete: :delete
    end
  end

  actions do
    defaults [:read]

    read :list_team_members do
      prepare build(load: :user)
    end

    create :add_team_member do
      accept [:user_id, :role]
    end

    update :change_member_role do
      accept [:role]
      validate one_of(:role, [:admin, :member])
    end

    destroy :remove_team_member

    destroy :leave_team do
      require_atomic? false

      change after_action(fn _changeset, team_member, context ->
               require Ash.Query

               # Check if the member who's leaving is an admin
               if team_member.role == "admin" do
                 # Count remaining admins in the team
                 remaining_admins =
                   Noted.Workspace.TeamMember
                   |> Ash.Query.set_tenant(context.tenant)
                   |> Ash.Query.filter(role == "admin" and id != ^team_member.id)
                   |> Ash.count!(authorize?: false)

                 # If no other admins remain, destroy the entire team
                 if remaining_admins == 0 do
                   context.tenant
                   |> Noted.Workspace.delete_team!(authorize?: false)
                 end
               end

               {:ok, team_member}
             end)
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if relates_to_actor_via([:team, :users])
    end

    policy action([:remove_team_member, :change_member_role]) do
      authorize_if expr(
                     ^actor(:role) == "admin" and
                       user_id != ^actor(:id) and
                       exists(team, users.id == ^actor(:id))
                   )
    end

    policy action(:leave_team) do
      authorize_if expr(user_id == ^actor(:id))
    end
  end

  multitenancy do
    strategy :attribute
    attribute :team_id
  end

  attributes do
    uuid_v7_primary_key :id
  end

  relationships do
    belongs_to :user, Noted.Accounts.User do
      public? true
      allow_nil? false
    end

    belongs_to :team, Noted.Workspace.Team do
      public? true
      allow_nil? false
    end

    belongs_to :team_role, Noted.Workspace.Role do
      public? true
      allow_nil? false
      source_attribute :role
      destination_attribute :name
      attribute_type :string
    end
  end

  calculations do
    calculate :can_manage,
              :boolean,
              expr(
                ^actor(:role) == "admin" and
                  user_id != ^actor(:id) and
                  exists(team, users.id == ^actor(:id))
              )
  end

  identities do
    identity :unique_user_membership, [:user_id, :team_id]
  end
end
