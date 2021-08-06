import babel from "@rollup/plugin-babel"
import { terser } from "rollup-plugin-terser"
import pkg from "./package.json"

export default {
  input: pkg.module,
  output: {
    file: pkg.main,
    format: "es"
  },
  plugins: [
    babel({ babelHelpers: 'bundled' }),
    terser({
      mangle: false,
      compress: false,
      format: {
        beautify: true,
        indent_level: 2
      }
    })
  ],
  external: ['stimulus']
}
