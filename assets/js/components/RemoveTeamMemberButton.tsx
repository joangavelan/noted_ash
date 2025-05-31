import { useForm } from "@inertiajs/react"

interface Props {
  memberId: string
}

export function RemoveTeamMemberButton({ memberId }: Props) {
  const { delete: destroy, processing } = useForm({ id: memberId })

  const removeTeamMember = () => {
    destroy("/workspace/remove-team-member")
  }

  return (
    <button onClick={removeTeamMember} className="btn btn-xs btn-error" disabled={processing}>
      Remove
    </button>
  )
}
