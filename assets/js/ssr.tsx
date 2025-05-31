import { createInertiaApp } from "@inertiajs/react"
import ReactDOMServer from "react-dom/server"
import { TanstackQueryProvider } from "./lib/tanstack-query"

export function render(page: any) {
  return createInertiaApp({
    page,
    render: ReactDOMServer.renderToString,
    resolve: async (name) => {
      return await import(`./pages/${name}.tsx`)
    },
    setup: ({ App, props }) => {
      const appElement = (
        <TanstackQueryProvider>
          <App {...props} />
        </TanstackQueryProvider>
      )

      return appElement
    }
  })
}
