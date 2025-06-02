import type { Role } from "@/types/team"
import { useQuery } from "@tanstack/react-query"
import { useDebounce } from "@uidotdev/usehooks"
import axios from "axios"
import { InviteUserButton } from "./InviteUserButton"

type UserSearchResult = {
  id: string
  name: string
  picture: string
  membership_status: Role | "invited" | null
}

interface Props {
  search: string
  setSearch: React.Dispatch<React.SetStateAction<string>>
}

async function fetchUsers(search: string, signal: AbortSignal) {
  const { data } = await axios.get<UserSearchResult[]>("/workspace/search-users", {
    params: { search },
    signal
  })
  return data
}

export function UserSearchResults({ search, setSearch }: Props) {
  const debouncedSearch = useDebounce(search, 300)

  const {
    data: users = [],
    isFetchedAfterMount,
    isFetching,
    isError,
    error
  } = useQuery({
    queryKey: ["users", debouncedSearch],
    queryFn: ({ signal }) => fetchUsers(debouncedSearch, signal)
  })

  if (!isFetchedAfterMount || isFetching) {
    return <Container>Loading...</Container>
  }

  if (isError) {
    return <Container>Error: {error.message}</Container>
  }

  if (users.length === 0) {
    return <Container>No users found</Container>
  }

  return (
    <Container>
      <ul className="list">
        {users.map(({ id, name, picture, membership_status }) => (
          <li key={id} className="list-row flex items-center justify-between">
            <div className="relative flex max-w-full items-center gap-2.5">
              <div className="avatar">
                <div className="w-10 rounded-full">
                  <img
                    src={
                      picture ||
                      "https://t4.ftcdn.net/jpg/02/15/84/43/360_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"
                    }
                    alt={name}
                  />
                </div>
              </div>
              <p>{name}</p>
            </div>

            <InviteUserButton
              userId={id}
              membershipStatus={membership_status}
              setSearch={setSearch}
            />
          </li>
        ))}
      </ul>
    </Container>
  )
}

function Container({ children }: { children: React.ReactNode }) {
  return (
    <div className="bg-base-200 absolute z-50 left-0 top-full mt-4 w-full rounded-sm">{children}</div>
  )
}
