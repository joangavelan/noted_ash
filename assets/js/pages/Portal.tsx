import { AcceptInvitationButton } from "@/components/AcceptInvitationButton"
import { DeclineInvitationButton } from "@/components/DeclineInvitationButton"
import { useChannel } from "@/hooks/useChannel"
import { useSocket } from "@/hooks/useSocket"
import { useUser } from "@/hooks/useUser"
import { Layout } from "@/layouts/Layout"
import { InvitationReceived, Team } from "@/types/team"
import { Link, router } from "@inertiajs/react"
import * as React from "react"

interface Props {
  teams: Team[]
  invitations: InvitationReceived[]
}

export default function Portal({ teams, invitations }: Props) {
  const { user } = useUser()

  const socket = useSocket()
  const channel = useChannel(socket, `user:${user?.id}`)

  React.useEffect(() => {
    if (!channel) return

    channel.on("invitations", () => {
      router.reload({ only: ["invitations"] })
    })

    channel.on("removed_from_team", () => {
      router.reload({ only: ["teams"] })
    })
  }, [channel])

  return (
    <Layout title="Portal">
      <h1>Multi-Tenant Notes App</h1>

      {user && (
        <div className="flex items-center gap-2.5">
          <div className="avatar">
            <div className="w-10 rounded-full">
              <img
                src={
                  user.picture ||
                  "https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"
                }
              />
            </div>
          </div>
          <p>{user.name}</p>
        </div>
      )}

      <Link href="/logout" method="delete" className="btn btn-secondary w-max">
        Logout
      </Link>

      <div className="divider"></div>

      <div className="flex items-center justify-between">
        <h2>Teams</h2>

        <Link href="/teams/new" as="button" className="btn btn-primary">
          New team
        </Link>
      </div>

      {teams.length > 0 ? (
        <ul>
          {teams.map(({ id, name }) => (
            <Link
              key={id}
              href="/enter-workspace"
              method="post"
              data={{ team_id: id }}
              as="button"
              className="btn"
            >
              {name} &rarr;
            </Link>
          ))}
        </ul>
      ) : (
        <p>No teams found.</p>
      )}

      <div className="divider"></div>

      <h2>Invitations</h2>

      {invitations.length > 0 ? (
        <ul>
          {invitations.map(({ invitation_id, team_id, team_name }) => (
            <li key={invitation_id} className="flex items-center gap-2.5">
              <p>
                You've been invited to the team <span className="font-semibold">{team_name}</span>!
              </p>
              <div className="flex gap-2.5">
                <AcceptInvitationButton invitationId={invitation_id} teamId={team_id} />
                <DeclineInvitationButton invitationId={invitation_id} teamId={team_id} />
              </div>
            </li>
          ))}
        </ul>
      ) : (
        <p>No invitations</p>
      )}
    </Layout>
  )
}
