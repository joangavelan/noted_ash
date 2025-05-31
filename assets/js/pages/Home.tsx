import { Layout } from "@/layouts/Layout"
import { Link } from "@inertiajs/react"

export default function Home() {
  return (
    <Layout title="Home">
      <h1>Noted</h1>

      <Link href="/portal" as="button" className="btn">
        Go to main application
      </Link>
    </Layout>
  )
}
