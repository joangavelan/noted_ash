import { ErrorField } from "@/components/ErrorField"
import { GoogleOAuthButton } from "@/components/GoogleOAuthButton"
import { Layout } from "@/layouts/Layout"
import { Link, useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

export default function Register() {
  const { data, setData, errors, post, processing } = useForm({
    name: "",
    email: "",
    password: "",
    password_confirmation: ""
  })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    post("/register")
  }

  return (
    <Layout title="Register">
      <h1 className="mb-1.5">Register</h1>

      <form onSubmit={handleSubmit} id="register-form" className="form">
        <fieldset className="form-field">
          <label htmlFor="name" className="label">
            Name
          </label>
          <input
            id="name"
            name="name"
            type="text"
            className="input"
            value={data.name}
            onChange={(e) => setData("name", e.target.value)}
          />
          <ErrorField error={errors.name} />
        </fieldset>

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
          <ErrorField error={errors.email} />
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
          <ErrorField error={errors.password} />
        </fieldset>

        <fieldset className="form-field">
          <label htmlFor="password_confirmation" className="label">
            Confirm password
          </label>
          <input
            id="password_confirmation"
            name="password_confirmation"
            type="password"
            className="input"
            value={data.password_confirmation}
            onChange={(e) => setData("password_confirmation", e.target.value)}
          />
          <ErrorField error={errors.password_confirmation} />
        </fieldset>

        <button className="btn btn-primary" type="submit" disabled={processing}>
          Register
        </button>
      </form>

      <div className="divider text-gray-500">or</div>

      <GoogleOAuthButton />

      <Link href="/login" className="link">
        Login
      </Link>
    </Layout>
  )
}
