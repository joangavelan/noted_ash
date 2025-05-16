export function ErrorField({ error }: { error?: string }) {
  if (!error) return null

  return <p className="text-error">{error}</p>
}
