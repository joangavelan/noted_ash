import { Head } from "@inertiajs/react"

interface Props {
  text: string
}

export default function Home({ text }: Props) {
  return (
    <>
      <Head title="Home" />

      <p className="text-lg text-green-500">{text}</p>
      <button className="btn btn-primary">Button</button>
    </>
  )
}
