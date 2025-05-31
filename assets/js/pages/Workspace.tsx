import { Back } from "@/components/Back"
import { CancelInvitationButton } from "@/components/CancelInvitationButton"
import { DeleteTeamButton } from "@/components/DeleteTeamButton"
import { InviteUserInput } from "@/components/InviteUserInput"
import { LeaveTeamButton } from "@/components/LeaveTeamButton"
import { RemoveTeamMemberButton } from "@/components/RemoveTeamMemberButton"
import { usePermissions } from "@/hooks/usePermissions"
import { Layout } from "@/layouts/Layout"
import type { InvitationSent, Team, TeamMember } from "@/types/team"

interface Props {
  current_team: Team
  team_members: TeamMember[]
  invitations_sent: InvitationSent[]
}

export default function Workspace({ current_team, team_members, invitations_sent }: Props) {
  const { can_invite_user, can_delete_team } = usePermissions()

  return (
    <Layout title={`${current_team.name} Team`}>
      <Back />

      <h1>{current_team.name} Team</h1>

      <div className="divider"></div>

      <div className="flex flex-col gap-2.5">
        <h2>Members</h2>

        <ul className="flex flex-col">
          {team_members.map(({ id, name, role, can_remove }) => (
            <li key={id} className="flex items-center gap-2.5">
              <p>
                {name} - {role}
              </p>

              {can_remove && <RemoveTeamMemberButton memberId={id} />}
            </li>
          ))}
        </ul>
      </div>

      <div className="divider"></div>

      {can_invite_user && (
        <div className="flex flex-col gap-2.5">
          <h2>Invitations</h2>

          <InviteUserInput />

          {invitations_sent.length > 0 ? (
            <ul>
              {invitations_sent.map(({ invitation_id, invited_user_name }) => (
                <li key={invitation_id} className="flex items-center gap-2.5">
                  <span>{invited_user_name}</span>
                  <CancelInvitationButton invitationId={invitation_id} />
                </li>
              ))}
            </ul>
          ) : (
            <p>No invitations sent</p>
          )}
        </div>
      )}

      <div className="fixed bottom-5 left-5 flex gap-2.5">
        <LeaveTeamButton />
        {can_delete_team && <DeleteTeamButton />}
      </div>
    </Layout>
  )
}
