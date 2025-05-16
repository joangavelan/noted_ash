import { Flash } from "@/components/Flash"
import { Head } from "@inertiajs/react"

interface Props {
  title: string
  children: React.ReactNode
}

export function Layout({ title, children }: Props) {
  return (
    <>
      <Head title={title} />

      <main className="flex w-max flex-col gap-2.5 p-2.5">{children}</main>

      <Flash />
    </>
  )
}
