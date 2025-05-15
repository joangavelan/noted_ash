import { Head } from "@inertiajs/react";

interface Props {
  text: string;
}

export default function Home({ text }: Props) {
  return (
    <>
      <Head title="Home" />

      <p>{text}</p>
    </>
  );
}
