import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  calculate() {
    this.element.requestSubmit();
  }
}
