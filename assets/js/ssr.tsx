import ReactDOMServer from "react-dom/server";
import { createInertiaApp } from "@inertiajs/react";

export function render(page: any) {
  return createInertiaApp({
    page,
    render: ReactDOMServer.renderToString,
    resolve: async (name) => {
      return await import(`./pages/${name}.tsx`);
    },
    setup: ({ App, props }) => <App {...props} />,
  });
}
