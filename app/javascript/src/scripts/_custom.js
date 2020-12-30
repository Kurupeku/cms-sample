import UIkit from "uikit";

(() => {
  // String variables
  const loadingHtml =
    '<div class="uk-width-expand uk-flex uk-flex-center uk-flex-middle uk-height-small"><div uk-spinner></div></div>';

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

  const contactFormInvalidMessage = (message) => {
    return `\
      <div class="uk-alert uk-alert-danger uk-width-1-1 uk-padding-small contact-form-alert">
        <p>${message}</p>
      </div>`;
  };

  const removePastAlert = (parent) => {
    const pastAlert = parent.querySelector(".contact-form-alert");
    pastAlert && pastAlert.remove();
    parent.querySelector("input, textarea").classList.remove("uk-form-danger");
  };

  const contactFormValidations = (e) => {
    const elm = e.target;
    const parent = elm.closest(".contact-form-control");
    removePastAlert(parent);

    const regexp = new RegExp(elm.dataset.regexp);
    if (!regexp.test(elm.value)) {
      parent.insertAdjacentHTML(
        "beforeend",
        contactFormInvalidMessage(elm.dataset.message)
      );
      UIkit.alert(parent.querySelector(".contact-form-alert"));
      parent.querySelector("input, textarea").classList.add("uk-form-danger");
    }
  };

  // Set global methods
  window.__customMethods = {};
  window.__customMethods.setLoadingSpinner = setLoadingSpinner;

  // onLoad
  window.addEventListener("DOMContentLoaded", () => {
    // HTMLElement variables
    const loadingTrigger = document.getElementsByClassName("loading-trigger");
    const contactForm = document.forms.contactForm;

    // SetEventListener
    for (let i = 0, len = loadingTrigger.length; i < len; i++)
      loadingTrigger[i].addEventListener("click", setLoadingSpinner);

    if (contactForm) {
      contactForm.querySelectorAll("input, textarea").forEach((elm) => {
        elm.addEventListener("blur", contactFormValidations);
      });
    }
  });
})();
