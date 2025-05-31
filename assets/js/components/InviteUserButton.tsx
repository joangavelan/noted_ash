import { Role } from "@/types/team"
import { useForm } from "@inertiajs/react"

interface Props {
  userId: string
  membershipStatus: Role | "invited" | null
  setSearch: React.Dispatch<React.SetStateAction<string>>
}

export function InviteUserButton({ userId, membershipStatus, setSearch }: Props) {
  const { post, processing } = useForm({ invited_user_id: userId })

  const inviteUser = () => {
    post("/workspace/invite-user", {
      onSuccess: () => setSearch("")
    })
  }

  return (
    <button
      onClick={() => inviteUser()}
      className="btn btn-sm w-24"
      disabled={Boolean(membershipStatus) || processing}
    >
      {processing ? "Inviting" : membershipStatus || "invite"}
    </button>
  )
}
