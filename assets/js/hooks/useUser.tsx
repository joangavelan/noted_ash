import type { User } from "@/types/user"
import type { PageProps } from "@inertiajs/core"
import { usePage } from "@inertiajs/react"

export function useUser(): { user: User | null } {
  const { current_user } = usePage<PageProps & { current_user: User | null }>().props
  return { user: current_user }
}
