import type { PageProps } from "@inertiajs/core"
import { usePage } from "@inertiajs/react"

type Permissions = {
  can_invite_user: boolean
  can_delete_team: boolean
}

export function usePermissions(): Permissions {
  const { permissions } = usePage<PageProps & { permissions: Permissions }>().props
  return permissions
}
