import { Back } from "@/components/Back"
import { ErrorField } from "@/components/ErrorField"
import { Layout } from "@/layouts/Layout"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

export default function NewTeam() {
  const { data, setData, post, processing, errors } = useForm({ name: "" })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    post("/teams")
  }

  return (
    <Layout title="New team">
      <Back />

      <h1>New Team</h1>

      <form onSubmit={handleSubmit} className="form">
        <fieldset className="form-field">
          <label htmlFor="name">Name</label>
          <input
            id="name"
            name="name"
            type="text"
            className="input"
            value={data.name}
            onChange={(e) => setData("name", e.target.value)}
          />
          <ErrorField error={errors.name} />

          <button type="submit" className="btn btn-primary" disabled={processing}>
            Create team
          </button>
        </fieldset>
      </form>
    </Layout>
  )
}
