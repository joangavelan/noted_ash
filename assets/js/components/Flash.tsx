import type { PageProps } from "@inertiajs/core"
import { router, usePage } from "@inertiajs/react"
import * as React from "react"

const flashKeyClass = {
  success: "alert-success",
  error: "alert-error",
  warning: "alert-warning",
  info: "alert-info"
}

type Flash = {
  [key: string]: string
}

export const Flash = () => {
  const { flash } = usePage<PageProps & { flash: Flash }>().props

  const flashKey = Object.keys(flash).find((key) => key in flashKeyClass) as
    | keyof typeof flashKeyClass
    | undefined

  const [visible, setVisible] = React.useState<boolean>(Boolean(flashKey))

  React.useEffect(() => {
    setVisible(Boolean(flashKey))
  }, [flash])

  const closeFlash = () => {
    setVisible(false)
    // Workaround to prevent the flash message from being displayed again after closing it
    // https://github.com/inertiajs/inertia/issues/64
    router.reload({ only: ["flash"] })
  }

  if (!flashKey || !visible) {
    return null
  }

  return (
    <div
      id="flash-message"
      role="alert"
      className={`alert fixed right-10 top-7 w-[18rem] cursor-pointer ${flashKeyClass[flashKey]}`}
      onClick={closeFlash}
    >
      <span>{flash[flashKey]}</span>
    </div>
  )
}
