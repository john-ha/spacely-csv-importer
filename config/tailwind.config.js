const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
  safelist: [
    "bg-red-50",
    "text-red-700",
    "ring-red-600/20",
    "bg-green-50",
    "text-green-700",
    "ring-green-600/20",
    "bg-blue-50",
    "text-blue-700",
    "ring-blue-600/20",
  ]
}
