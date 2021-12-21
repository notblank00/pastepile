window.addEventListener('turbolinks:load', () => {
  document.getElementById('btn-copy').addEventListener('click', () => {
    navigator.clipboard.writeText(text);
  });
});