import { Link } from "@inertiajs/react"

interface Props {
  href: string
  destination: string
}

export function Back({ href, destination }: Props) {
  return (
    <Link href={href} className="link">
      Go back to {destination}
    </Link>
  )
}
