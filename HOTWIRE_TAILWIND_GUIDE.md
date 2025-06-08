# Hotwire & Tailwind CSS Integration Guide

This guide shows how to use Hotwire (Turbo + Stimulus) and Tailwind CSS with Sitepress in a no-build setup.

## What's Included

✅ **Hotwire Turbo** - Fast navigation without full page reloads  
✅ **Stimulus** - Modest JavaScript framework for adding behavior  
✅ **Tailwind CSS** - Utility-first CSS framework  
✅ **No build tools** - Everything works without npm/webpack/esbuild  

## Quick Start

The dummy application in `sitepress-rails/spec/dummy` demonstrates the complete setup. Visit `/hotwire_demo.html` to see all features working together.

## File Structure

```
app/
├── assets/
│   ├── javascripts/
│   │   ├── application.js              # Main entry point
│   │   └── controllers/
│   │       ├── index.js                # Stimulus loader
│   │       ├── application.js          # Stimulus app setup
│   │       ├── hello_controller.js     # Example controller
│   │       └── counter_controller.js   # Interactive demo
│   └── stylesheets/
│       └── application.css             # CSS (works with Tailwind)
├── views/layouts/
│   └── application.html.erb           # Layout with Tailwind CDN
└── content/pages/
    └── hotwire_demo.html.erb          # Demo page

config/
└── importmap.rb                       # JavaScript module definitions
```

## Setup Instructions

### 1. Importmap Configuration

Add Hotwire dependencies to `config/importmap.rb`:

```ruby
# config/importmap.rb
pin "application", preload: true

# Hotwire dependencies
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"  
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/assets/javascripts/controllers", under: "controllers"
```

### 2. Application JavaScript

Update `app/assets/javascripts/application.js`:

```javascript
// app/assets/javascripts/application.js
import "@hotwired/turbo-rails"
import "controllers"

console.log("Sitepress with Hotwire loaded!")
```

### 3. Stimulus Setup

Create controller files:

```javascript
// app/assets/javascripts/controllers/application.js
import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }
```

```javascript
// app/assets/javascripts/controllers/index.js
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)
```

### 4. Example Stimulus Controller

```javascript
// app/assets/javascripts/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  greet() {
    this.outputTarget.textContent = "Hello from Stimulus!"
  }
}
```

### 5. Layout with Tailwind

Update your layout file:

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>Your Site</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Propshaft CSS -->
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    
    <!-- Importmap JavaScript -->
    <%= javascript_importmap_tags %>
  </head>
  <body class="bg-gray-50">
    <%= yield %>
  </body>
</html>
```

### 6. Using in Pages

```erb
<!-- pages/example.html.erb -->
---
title: "Example Page"
---

<div class="max-w-4xl mx-auto p-8">
  <h1 class="text-3xl font-bold text-blue-600">Hello Sitepress!</h1>
  
  <!-- Stimulus controller -->
  <div data-controller="hello" class="mt-8">
    <button 
      data-action="click->hello#greet" 
      class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
    >
      Click me!
    </button>
    <div data-hello-target="output" class="mt-4"></div>
  </div>
  
  <!-- Turbo navigation -->
  <a href="/other-page.html" class="text-blue-500 hover:underline">
    Navigate with Turbo
  </a>
</div>
```

## Tailwind CSS Options

### Option 1: CDN (Development)
Perfect for getting started quickly:

```html
<script src="https://cdn.tailwindcss.com"></script>
```

### Option 2: Standalone CLI (Production)
For production apps, use the Tailwind CLI:

```bash
# Download Tailwind CLI
curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64

# Generate CSS
./tailwindcss-linux-x64 -i app/assets/stylesheets/application.css -o public/stylesheets/application.css --watch
```

### Option 3: tailwindcss-rails Gem
Add to your Gemfile for Rails integration:

```ruby
gem 'tailwindcss-rails'
```

## Deployment with Kamal 2

For deploying with Kamal 2, your `Dockerfile` can be simple:

```dockerfile
FROM ruby:3.2

WORKDIR /app
COPY Gemfile* ./
RUN bundle install --without development test

COPY . .

# For Tailwind standalone CLI (optional)
RUN curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64 && \
    chmod +x tailwindcss-linux-x64 && \
    ./tailwindcss-linux-x64 -i app/assets/stylesheets/application.css -o public/stylesheets/application.css --minify

EXPOSE 8080
CMD ["sitepress", "server", "--bind-address", "0.0.0.0"]
```

`config/deploy.yml`:

```yaml
service: my-sitepress-site
image: my-registry/sitepress-site

servers:
  - your-server-ip

env:
  secret:
    - RAILS_MASTER_KEY

proxy:
  host: example.com
```

## Benefits

- ✅ **Zero build complexity** - No webpack, esbuild, or npm required
- ✅ **Fast development** - Instant reloads without compilation
- ✅ **Modern UX** - Turbo navigation + Stimulus interactivity  
- ✅ **Beautiful styling** - Tailwind utility classes
- ✅ **Rails conventions** - Familiar importmap + propshaft approach
- ✅ **Production ready** - Can compile Tailwind for optimization

## Examples in Action

Visit the demo page at `/hotwire_demo.html` in the dummy app to see:

- Turbo navigation between pages
- Stimulus controllers adding interactivity
- Tailwind CSS styling everything beautifully
- All working together without any build step

This setup gives you the full modern web development experience while maintaining Rails 8's philosophy of simplicity and convention over configuration.