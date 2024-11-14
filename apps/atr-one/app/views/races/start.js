console.log("Race started");

const button = document.getElementById("start_button");
if (button) {
  button.disabled = true;
  button.classList.add("disabled:cursor-not-allowed");
}