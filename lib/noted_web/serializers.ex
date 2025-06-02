defmodule NotedWeb.Serializers do
  def serialize_user(user) when is_map(user) do
    Map.take(user, [:id, :name, :email, :picture])
  end

  def serialize_user(_), do: nil

  def serialize_user_with_membership(user) when is_map(user) do
    Map.take(user, [:id, :name, :email, :picture, :role, :membership_id])
  end

  def serialize_team(team) when is_map(team) do
    Map.take(team, [:id, :name])
  end

  def serialize_teams(teams) when is_list(teams) do
    Enum.map(teams, &serialize_team/1)
  end

  def serialize_team_member(member) when is_map(member) do
    %{
      id: member.id,
      name: member.user.name,
      role: member.role,
      can_manage: member.can_manage
    }
  end

  def serialize_team_members(members) when is_list(members) do
    Enum.map(members, &serialize_team_member/1)
  end

  def serialize_invitation_sent(invitation) when is_map(invitation) do
    %{
      invitation_id: invitation.id,
      invited_user_name: invitation.invited_user.name
    }
  end

  def serialize_invitations_sent(invitations) when is_list(invitations) do
    Enum.map(invitations, &serialize_invitation_sent/1)
  end

  def serialize_user_search_result(user) when is_map(user) do
    Map.take(user, [:id, :name, :picture, :membership_status])
  end

  def serialize_user_search_results(users) when is_list(users) do
    Enum.map(users, &serialize_user_search_result/1)
  end

  def serialize_invitation_received(invitation) when is_map(invitation) do
    %{
      invitation_id: invitation.id,
      team_id: invitation.team.id,
      team_name: invitation.team.name
    }
  end

  def serialize_invitations_received(invitations) when is_list(invitations) do
    Enum.map(invitations, &serialize_invitation_received/1)
  end

  def serialize_listed_note(note) when is_map(note) do
    Map.take(note, [:id, :title, :content, :author, :can_update, :can_destroy])
  end

  def serialize_listed_notes(notes) when is_list(notes) do
    Enum.map(notes, &serialize_listed_note/1)
  end

  def serialize_note_for_editing(note) when is_map(note) do
    Map.take(note, [:id, :title, :content])
  end
end
