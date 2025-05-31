import { useForm } from "@inertiajs/react"

interface Props {
  invitationId: string
  teamId: string
}

export function DeclineInvitationButton({ invitationId, teamId }: Props) {
  const { delete: destroy, processing } = useForm({ invitation_id: invitationId, team_id: teamId })

  const declineInvitation = () => {
    destroy("/decline-invitation")
  }

  return (
    <button onClick={declineInvitation} className="btn btn-sm" disabled={processing}>
      Decline
    </button>
  )
}
