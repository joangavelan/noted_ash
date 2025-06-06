import type { Channel, Socket } from "phoenix"
import * as React from "react"

export function useChannel(socket: Socket | null, topic: string, params = {}) {
  const [channel, setChannel] = React.useState<Channel | null>(null)

  React.useEffect(() => {
    if (!socket) return

    const newChannel = socket.channel(topic, params)
    newChannel
      .join()
      .receive("ok", () => console.log(`Joined channel: ${topic}`))
      .receive("error", (resp) => console.error(`Unable to join: ${topic}`, resp))

    setChannel(newChannel)

    return () => {
      newChannel.leave()
    }
  }, [socket])

  return channel
}
