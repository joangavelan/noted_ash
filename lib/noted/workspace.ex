defmodule Noted.Workspace do
  use Ash.Domain,
    otp_app: :noted

  resources do
    resource Noted.Workspace.Team do
      define :create_team
      define :list_user_teams
      define :get_team, action: :read, get_by: :id
      define :delete_team, action: :destroy
    end

    resource Noted.Workspace.Invitation do
      define :list_received_invitations
      define :invite_user
      define :list_invitations_sent
      define :cancel_invitation
      define :decline_invitation
      define :accept_invitation
    end

    resource Noted.Workspace.TeamMember do
      define :add_team_member
      define :list_team_members
      define :remove_team_member
      define :leave_team
      define :get_member, action: :read, get_by: [:user_id, :team_id]
    end

    resource Noted.Workspace.Role
  end
end
