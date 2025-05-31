import { useForm } from "@inertiajs/react"

interface Props {
  invitationId: string
}

export function CancelInvitationButton({ invitationId }: Props) {
  const { delete: destroy, processing } = useForm({ id: invitationId })

  const cancelInvitation = () => {
    destroy("/workspace/cancel-invitation")
  }

  return (
    <button onClick={cancelInvitation} className="btn btn-sm" disabled={processing}>
      Cancel
    </button>
  )
}
