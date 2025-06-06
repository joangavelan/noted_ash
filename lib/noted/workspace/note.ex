defmodule Noted.Workspace.Note do
  use Ash.Resource,
    otp_app: :noted,
    domain: Noted.Workspace,
    authorizers: [Ash.Policy.Authorizer],
    notifiers: [Ash.Notifier.PubSub],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "notes"
    repo Noted.Repo

    references do
      reference :team, on_delete: :delete, index?: true
      reference :team_member, on_delete: :delete, index?: true
    end
  end

  actions do
    default_accept [:title, :content]
    defaults [:read, :destroy, update: :*]

    read :list_notes do
      prepare build(load: [:author, :can_update, :can_destroy])
    end

    create :create_note do
      change relate_actor(:team_member, field: :membership_id)
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if relates_to_actor_via([:team, :users])
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via([:team_member, :user])
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via([:team_member, :user])
      authorize_if actor_attribute_equals(:role, "admin")
    end
  end

  pub_sub do
    module NotedWeb.Endpoint

    publish_all :create, ["notes", :_tenant]
    publish_all :update, ["notes", :_tenant]
    publish_all :destroy, ["notes", :_tenant]
  end

  multitenancy do
    strategy :attribute
    attribute :team_id
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :title, :string do
      allow_nil? false
      public? true
      constraints min_length: 3, max_length: 50
    end

    attribute :content, :string do
      allow_nil? false
      public? true
      constraints min_length: 3, max_length: 100
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :team_member, Noted.Workspace.TeamMember do
      allow_nil? false
    end

    belongs_to :team, Noted.Workspace.Team do
      allow_nil? false
    end
  end

  calculations do
    calculate :author, :string, expr(team_member.user.name)
    calculate :can_update, :boolean, {Noted.Calculations.CanPerformAction, action: :update}
    calculate :can_destroy, :boolean, {Noted.Calculations.CanPerformAction, action: :destroy}
  end
end
