import { useForm } from "@inertiajs/react"

export function DeleteTeamButton() {
  const { delete: destroy, processing } = useForm()

  const deleteTeam = () => {
    destroy("/workspace/delete-team")
  }

  return (
    <button onClick={deleteTeam} className="btn btn-sm btn-error" disabled={processing}>
      Delete Team
    </button>
  )
}
