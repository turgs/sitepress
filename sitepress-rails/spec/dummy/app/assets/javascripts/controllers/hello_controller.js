import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hello"
export default class extends Controller {
  static targets = ["output"]

  connect() {
    console.log("Hello controller connected!")
  }

  greet() {
    this.outputTarget.textContent = "Hello from Stimulus!"
  }
}