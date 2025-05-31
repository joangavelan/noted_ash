import { createInertiaApp } from "@inertiajs/react"
import axios from "axios"
import { hydrateRoot } from "react-dom/client"
import { TanstackQueryProvider } from "./lib/tanstack-query"

axios.defaults.xsrfHeaderName = "x-csrf-token"

createInertiaApp({
  title: (title) => `${title} · Noted`,
  resolve: async (name) => {
    return await import(`./pages/${name}.tsx`)
  },
  setup({ App, el, props }) {
    const appElement = (
      <TanstackQueryProvider>
        <App {...props} />
      </TanstackQueryProvider>
    )

    hydrateRoot(el, appElement)
  }
})
