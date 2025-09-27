// tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.html.erb',   // All your Rails view templates
    './app/helpers/**/*.rb',       // If you output classes from helpers
    './app/javascript/**/*.js',    // If you use JS to toggle classes
    './app/components/**/*.{erb,rb}', // If you use ViewComponent or partials
    './public/*.html'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
