import { defineConfig } from 'vite'
import elmPlugin from 'vite-plugin-elm'

export default defineConfig(({ command }) => {
  const optimizeElmBundle = command === 'build'

  return {
    plugins: [
      elmPlugin({
        debug: !optimizeElmBundle,
        optimize: optimizeElmBundle,
      }),
    ],
    build: {
      target: 'esnext',
      // Add [Elm-specific minification rules](https://guide.elm-lang.org/optimization/asset_size.html)
      // to esbuild once [this issue](https://github.com/vitejs/vite/issues/5489) is solved.
    },
    server: {
      port: 3000,
      strictPort: true,
    },
  }
})
