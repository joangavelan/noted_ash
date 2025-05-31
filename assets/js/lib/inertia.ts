import type { PageProps } from "@inertiajs/core"
import { router } from "@inertiajs/react"

type UpdateCallback = (currentProps: PageProps) => Partial<PageProps>

export function updateInertiaProps(updateCallback: UpdateCallback) {
  router.replace({
    props: (currentProps) => ({ ...currentProps, ...updateCallback(currentProps) })
  })
}
