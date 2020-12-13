(() => {
  // String variables
  const loadingHtml =
    '<div class="uk-width-expand uk-flex uk-flex-center uk-flex-middle uk-height-small"><div uk-spinner></div></div>';

  // HTMLElement variables
  const elms = document.getElementsByClassName("loading-trigger");

  // Methods
  const setLoadingSpinner = (e) => {
    const currentElm = e.target;
    if (currentElm) {
      const targetId = currentElm.dataset.target;
      if (targetId) {
        const targetElm = document.getElementById(targetId.replace("#", ""));
        if (targetElm) targetElm.innerHTML = loadingHtml;
      }
    }
  };

  // Set global methods
  window.__customMethods = {};
  window.__customMethods.setLoadingSpinner = setLoadingSpinner;

  // EventListener
  window.addEventListener("DOMContentLoaded", () => {
    for (let i = 0, len = elms.length; i < len; i++)
      elms[i].addEventListener("click", setLoadingSpinner);
  });
})();
