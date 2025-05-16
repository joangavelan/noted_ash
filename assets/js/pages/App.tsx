import { useUser } from "@/hooks/useUser"
import { Layout } from "@/layouts/Layout"
import { Link } from "@inertiajs/react"

export default function App() {
  const { user } = useUser()

  return (
    <Layout title="App">
      <h1>Multi-Tenant Notes App</h1>

      {user && (
        <div className="flex items-center gap-2.5">
          <div className="avatar">
            <div className="w-10 rounded-full">
              <img
                src={
                  user.picture ||
                  "https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"
                }
              />
            </div>
          </div>
          <p>{user.name}</p>
        </div>
      )}

      <Link href="/logout" method="delete" className="btn btn-secondary">
        Logout
      </Link>
    </Layout>
  )
}
