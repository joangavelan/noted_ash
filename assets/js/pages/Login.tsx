import { GoogleOAuthButton } from "@/components/GoogleOAuthButton"
import { Layout } from "@/layouts/Layout"
import { Link, useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

export default function Login() {
  const { data, setData, post, processing } = useForm({
    email: "",
    password: ""
  })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    post("/login")
  }

  return (
    <Layout title="Login">
      <h1 className="mb-1.5">Login</h1>

      <form onSubmit={handleSubmit} className="form">
        <fieldset className="form-field">
          <label htmlFor="email" className="label">
            Email
          </label>
          <input
            id="email"
            name="email"
            type="email"
            className="input"
            value={data.email}
            onChange={(e) => setData("email", e.target.value)}
          />
        </fieldset>

        <fieldset className="form-field">
          <label htmlFor="password" className="label">
            Password
          </label>
          <input
            id="password"
            name="password"
            type="password"
            className="input"
            value={data.password}
            onChange={(e) => setData("password", e.target.value)}
          />
        </fieldset>

        <button className="btn btn-primary" type="submit" disabled={processing}>
          Login
        </button>
      </form>

      <div className="divider text-gray-500">or</div>

      <GoogleOAuthButton />

      <Link href="/register" className="link">
        Register
      </Link>
    </Layout>
  )
}
