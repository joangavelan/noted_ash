import { Back } from "@/components/Back"
import { NoteForm } from "@/components/NoteForm"
import { Layout } from "@/layouts/Layout"
import { Note } from "@/types/note"

interface Props {
  note: Note
}

export default function EditNote({ note }: Props) {
  return (
    <Layout title="Edit note">
      <Back href="/workspace" destination="Workspace" />

      <h1>Edit note</h1>

      <NoteForm note={note} />
    </Layout>
  )
}
