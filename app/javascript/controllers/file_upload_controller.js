import { Controller } from "@hotwired/stimulus"

const FILE_SIZE_LIMIT = 20
export default class extends Controller {
  static targets = [ "input", "filename", "placeholder", "submit" ]

  connect() { this.#resetInput() }

  // This method is called when the user selects a file from the file input
  onInputChange() {
    if (this.inputTarget.files.length === 0) {
      this.#resetInput()
    } else {
      const fileSize = this.#bytesToMegaBytes(this.inputTarget.files[0].size)

      if (fileSize > FILE_SIZE_LIMIT) {
        alert("File size must be less than 20 MB")
        this.#resetInput()
        return
      }

      this.#showFilename()
    }
  }

  /******************
   * Private methods
   ******************/

  // Reset the input field and show the placeholder text
  #resetInput() {
    this.inputTarget.value = ""
    this.filenameTarget.textContent = ""
    this.placeholderTarget.classList.remove("hidden")
    this.submitTarget.disabled = true
  }

  // Show the name and size of the selected file
  #showFilename() {
    this.placeholderTarget.classList.add("hidden")
    this.filenameTarget.textContent = `${this.inputTarget.files[0].name} (${this.#bytesToMegaBytes(this.inputTarget.files[0].size)} MB)`
    this.submitTarget.disabled = false
  }

  // Convert bytes to megabytes
  #bytesToMegaBytes(bytes) {
    return (bytes / 1024 / 1024).toFixed(2)
  }
}
