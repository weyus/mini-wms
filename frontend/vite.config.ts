import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import svgr from "vite-plugin-svgr";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    svgr({
      svgrOptions: {
        dimensions: false,
        replaceAttrValues: { "#1C2C43": "currentColor" },
        // https://a11y-guidelines.orange.com/en/articles/accessible-svg/
        svgProps: { "aria-hidden": "true", focusable: "false" },
        svgo: true,
      },
    }),
  ],
  server: {
    host: "127.0.0.1",
    port: 5173,
    strictPort: true,
  },
});
