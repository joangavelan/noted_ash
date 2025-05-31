type Team = {
  id: string
  name: string
}

type Role = "admin" | "member"

type TeamMember = {
  id: string
  name: string
  role: Role
  can_remove: boolean
}

type InvitationSent = {
  invitation_id: string
  invited_user_name: string
}

type InvitationReceived = {
  invitation_id: string
  team_id: string
  team_name: string
}

export type { InvitationReceived, InvitationSent, Role, Team, TeamMember }
