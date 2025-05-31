import * as React from "react"
import { UserSearchResults } from "./UserSearchResults"

export function InviteUserInput() {
  const [search, setSearch] = React.useState("")

  return (
    <div className="w-92 relative">
      <input
        id="search"
        name="search"
        type="text"
        className="input"
        placeholder="Search users..."
        autoComplete="off"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      {search && <UserSearchResults search={search} setSearch={setSearch} />}
    </div>
  )
}
