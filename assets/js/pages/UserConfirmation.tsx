import { Layout } from "@/layouts/Layout"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

interface Props {
  token: string
}

export default function UserConfirmation({ token }: Props) {
  const { put, processing } = useForm()

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()
    put(`/confirm-new-user/${token}`)
  }

  return (
    <Layout title="Confirm new user">
      <h1>User Confirmation</h1>
      <form onSubmit={handleSubmit}>
        <button className="btn btn-primary" type="submit" disabled={processing}>
          Confirm
        </button>
      </form>
    </Layout>
  )
}
