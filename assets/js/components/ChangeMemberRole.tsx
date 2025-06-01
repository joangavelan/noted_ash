import { useForm } from "@inertiajs/react"
import { useIsFirstRender } from "@uidotdev/usehooks"
import * as React from "react"

interface Props {
  memberId: string
  currentRole: string
}

export function ChangeMemberRole({ memberId, currentRole }: Props) {
  const { data, setData, put, processing } = useForm({
    member_id: memberId,
    role: currentRole
  })

  const isFirstRender = useIsFirstRender()

  const changeRole = () => {
    put("/workspace/change-member-role")
  }

  React.useEffect(() => {
    if (!isFirstRender) {
      changeRole()
    }
  }, [data.role])

  return (
    <select
      defaultValue={data.role}
      className="select select-xs"
      onChange={(e) => setData("role", e.target.value)}
      disabled={processing}
    >
      <option value="admin">Admin</option>
      <option value="member">Member</option>
    </select>
  )
}
