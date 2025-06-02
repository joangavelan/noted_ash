import { useForm } from "@inertiajs/react"

interface Props {
  noteId: string
}

export function DeleteNoteButton({ noteId }: Props) {
  const { delete: destroy, processing } = useForm({ id: noteId })

  const deleteNote = () => {
    destroy(`/workspace/notes/${noteId}`)
  }

  return (
    <button onClick={deleteNote} className="btn btn-sm" disabled={processing}>
      Delete
    </button>
  )
}
