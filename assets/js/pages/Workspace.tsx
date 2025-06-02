import { Back } from "@/components/Back"
import { CancelInvitationButton } from "@/components/CancelInvitationButton"
import { ChangeMemberRole } from "@/components/ChangeMemberRole"
import { DeleteNoteButton } from "@/components/DeleteNoteButton"
import { DeleteTeamButton } from "@/components/DeleteTeamButton"
import { InviteUserInput } from "@/components/InviteUserInput"
import { LeaveTeamButton } from "@/components/LeaveTeamButton"
import { RemoveTeamMemberButton } from "@/components/RemoveTeamMemberButton"
import { usePermissions } from "@/hooks/usePermissions"
import { Layout } from "@/layouts/Layout"
import { Note } from "@/types/note"
import type { InvitationSent, Team, TeamMember } from "@/types/team"
import { Link } from "@inertiajs/react"

interface Props {
  current_team: Team
  team_members: TeamMember[]
  invitations_sent: InvitationSent[]
  notes: Note[]
}

export default function Workspace({ current_team, team_members, invitations_sent, notes }: Props) {
  const { can_invite_user, can_delete_team } = usePermissions()

  return (
    <Layout title={`${current_team.name} Team`}>
      <Back href="/portal" destination="Portal" />

      <h1>{current_team.name} Team</h1>

      <div className="divider"></div>

      <div className="flex flex-col gap-2.5">
        <h2>Members</h2>

        <ul className="flex flex-col">
          {team_members.map(({ id, name, role, can_manage }) => (
            <li key={id} className="flex items-center gap-2.5">
              <p>
                {name} - {role}
              </p>

              {can_manage && (
                <div className="flex items-center gap-2.5">
                  <ChangeMemberRole memberId={id} currentRole={role} />
                  <RemoveTeamMemberButton memberId={id} />
                </div>
              )}
            </li>
          ))}
        </ul>
      </div>

      {can_invite_user && (
        <>
          <div className="divider"></div>

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
        </>
      )}

      <div className="divider"></div>

      <div className="flex flex-col gap-2.5">
        <div className="flex justify-between gap-2.5">
          <h2>Notes</h2>
          <Link href="/workspace/notes/new" as="button" className="btn btn-sm btn-primary">
            New note
          </Link>
        </div>

        {notes.length > 0 ? (
          <ul className="flex flex-col gap-2.5">
            {notes.map(({ id, title, content, author, can_update, can_destroy }) => (
              <li key={id} className="card card-border bg-base-100 w-96">
                <div className="card-body">
                  <h2 className="card-title">{title}</h2>
                  <p>{content}</p>
                  <p className="text-sm label">- {author}</p>
                  <div className="card-actions justify-end">
                    {can_update && (
                      <Link href={`/workspace/notes/${id}/edit`} className="btn btn-sm">
                        Edit
                      </Link>
                    )}
                    {can_destroy && <DeleteNoteButton noteId={id} />}
                  </div>
                </div>
              </li>
            ))}
          </ul>
        ) : (
          <p>No note has been created yet</p>
        )}
      </div>

      <div className="fixed bottom-5 right-5 flex gap-2.5">
        <LeaveTeamButton />
        {can_delete_team && <DeleteTeamButton />}
      </div>
    </Layout>
  )
}
