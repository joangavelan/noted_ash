import { useForm } from "@inertiajs/react"

interface Props {
  invitationId: string
  teamId: string
}

export function AcceptInvitationButton({ invitationId, teamId }: Props) {
  const { post, processing } = useForm({ invitation_id: invitationId, team_id: teamId })

  const acceptInvitation = () => {
    post("/accept-invitation")
  }

  return (
    <button onClick={acceptInvitation} className="btn btn-sm" disabled={processing}>
      Accept
    </button>
  )
}
