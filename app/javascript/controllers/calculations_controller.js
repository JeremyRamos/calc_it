import { Controller } from "@hotwired/stimulus"
import debounce from "debounce";

export default class extends Controller {

  initialize() {
    this.calculate = debounce(this.calculate.bind(this), 300);
  }
  calculate() {
    this.element.requestSubmit();
  }
}
