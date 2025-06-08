import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  static targets = ["count"]

  connect() {
    this.count = 0
    console.log("Counter controller connected!")
  }

  increment() {
    this.count++
    this.countTarget.textContent = this.count
  }

  decrement() {
    this.count--
    this.countTarget.textContent = this.count
  }
}