import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "filename", "placeholder", "submit" ]

  connect() { this.#resetInput() }

  onInputChange() {
    if (this.inputTarget.files.length === 0) {
      this.#resetInput()
    } else {
      const filesize = this.#bytesToMegaBytes(this.inputTarget.files[0].size)

      if (filesize > 10) {
        alert("File size must be less than 10 MB")
        this.#resetInput()
        return
      }

      this.#showFilename()
    }
  }

  #resetInput() {
    this.inputTarget.value = ""
    this.filenameTarget.textContent = ""
    this.placeholderTarget.classList.remove("hidden")
    this.submitTarget.disabled = true
  }

  #showFilename() {
    this.placeholderTarget.classList.add("hidden")
    this.filenameTarget.textContent = `${this.inputTarget.files[0].name} (${this.#bytesToMegaBytes(this.inputTarget.files[0].size)} MB)`
    this.submitTarget.disabled = false
  }

  #bytesToMegaBytes(bytes) {
    return (bytes / 1024 / 1024).toFixed(2)
  }
}
