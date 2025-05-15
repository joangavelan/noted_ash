import axios from "axios";
import { createInertiaApp } from "@inertiajs/react";
import { hydrateRoot } from "react-dom/client";

axios.defaults.xsrfHeaderName = "x-csrf-token";

createInertiaApp({
  title: (title) => `${title} · Noted`,
  resolve: async (name) => {
    return await import(`./pages/${name}.tsx`);
  },
  setup({ App, el, props }) {
    hydrateRoot(el, <App {...props} />);
  },
});
