import { Role } from "./team"

type User = {
  id: string
  name: string
  email: string
  picture: string | null
  role?: Role
}

export type { User }
