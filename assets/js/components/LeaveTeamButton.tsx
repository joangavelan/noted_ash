import { useForm } from "@inertiajs/react"

export function LeaveTeamButton() {
  const { delete: destroy, processing } = useForm()

  const leaveTeam = () => {
    destroy("/workspace/leave-team")
  }

  return (
    <button onClick={leaveTeam} className="btn btn-sm btn-error" disabled={processing}>
      Leave Team
    </button>
  )
}
