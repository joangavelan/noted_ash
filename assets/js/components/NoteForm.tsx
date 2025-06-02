import { ErrorField } from "@/components/ErrorField"
import { Note } from "@/types/note"
import { useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

interface Props {
  note?: Note
}

export function NoteForm({ note }: Props) {
  const { data, setData, post, put, transform, processing, errors } = useForm({
    title: note?.title || "",
    content: note?.content || ""
  })

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault()

    if (note) {
      // User is editing a note
      transform((data) => ({
        id: note.id,
        note: { ...data }
      }))

      put(`/workspace/notes/${note.id}`)
    } else {
      // User is creating a new note
      post("/workspace/notes")
    }
  }

  return (
    <form onSubmit={handleSubmit} className="form">
      <fieldset className="form-field">
        <label htmlFor="title" className="label">
          Title
        </label>
        <input
          id="title"
          name="title"
          type="text"
          className="input"
          value={data.title}
          onChange={(e) => setData("title", e.target.value)}
        />
        <ErrorField error={errors.title} />
      </fieldset>

      <fieldset className="form-field">
        <label htmlFor="content" className="label">
          Content
        </label>
        <input
          id="content"
          name="content"
          type="text"
          className="input"
          value={data.content}
          onChange={(e) => setData("content", e.target.value)}
        />
        <ErrorField error={errors.content} />
      </fieldset>

      <button className="btn btn-primary" type="submit" disabled={processing}>
        {note ? "Update note" : "Create note"}
      </button>
    </form>
  )
}
