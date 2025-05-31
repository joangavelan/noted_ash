import type { PageProps } from "@inertiajs/core"
import { router, usePage } from "@inertiajs/react"

const flashTypeClass = {
  success: "alert-success",
  error: "alert-error",
  warning: "alert-warning",
  info: "alert-info"
}

type FlashType = keyof typeof flashTypeClass

type Flash = Record<FlashType, string>

function clearFlash() {
  router.replace({
    props: (currentProps) => ({
      ...currentProps,
      flash: {}
    }),
    preserveState: true,
    preserveScroll: true
  })
}

export function Flash() {
  const { flash } = usePage<PageProps & { flash: Flash }>().props
  const flashKey = Object.keys(flash).find((key) => key in flashTypeClass) as FlashType | undefined

  if (!flashKey) {
    return null
  }

  return (
    <div
      id="flash-message"
      role="alert"
      className={`alert fixed right-10 top-7 w-[18rem] cursor-pointer ${flashTypeClass[flashKey]}`}
      onClick={clearFlash}
    >
      <span>{flash[flashKey]}</span>
    </div>
  )
}
