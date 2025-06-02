import { Back } from "@/components/Back"
import { NoteForm } from "@/components/NoteForm"
import { Layout } from "@/layouts/Layout"

export default function NewNote() {
  return (
    <Layout title="New note">
      <Back href="/workspace" destination="Workspace" />

      <h1>New note</h1>

      <NoteForm />
    </Layout>
  )
}
