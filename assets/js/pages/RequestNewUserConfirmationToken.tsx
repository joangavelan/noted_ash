import { ErrorField } from "@/components/ErrorField"
import { Layout } from "@/layouts/Layout"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

export default function RequestNewUserConfirmationToken() {
  const { data, setData, post, processing, errors } = useForm({ email: "" })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    post("/confirm-new-user")
  }

  return (
    <Layout title="New user confirmation">
      <div>
        <h1>Didn't receive the confirmation link?</h1>
        <p>Enter your email to receive new instructions.</p>
      </div>

      <form onSubmit={handleSubmit} className="form">
        <fieldset className="form-field">
          <label htmlFor="email" className="label">
            Email
          </label>
          <input
            id="email"
            type="email"
            name="email"
            className="input"
            value={data.email}
            onChange={(e) => setData("email", e.target.value)}
          />
          <ErrorField error={errors.email} />
        </fieldset>

        <button className="btn btn-primary" type="submit" disabled={processing}>
          Send new instructions
        </button>
      </form>
    </Layout>
  )
}
