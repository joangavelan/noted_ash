import { Socket } from "phoenix"
import * as React from "react"

export function useSocket() {
  const [socket, setSocket] = React.useState<Socket | null>(null)

  React.useEffect(() => {
    const newSocket = new Socket("/socket", {
      // @ts-ignore
      params: { token: window.userToken }
    })

    newSocket.connect()

    setSocket(newSocket)

    return () => {
      newSocket.disconnect()
    }
  }, [])

  return socket
}
