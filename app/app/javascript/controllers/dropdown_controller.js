import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    // Alterna a visibilidade do menu
    this.menuTarget.classList.toggle("hidden")
  }

  // (Opcional) Fecha o menu se clicar fora dele
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}