import UIkit from "uikit";

(() => {
  // variables
  const loadingHtml =
    '<div class="uk-width-expand uk-flex uk-flex-center uk-flex-middle uk-height-small"><div uk-spinner></div></div>';

  const mediaQuery_lt_md = matchMedia("(max-width: 640px)");

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
      <div class="contact-form-alert uk-alert-danger uk-width-1-1 uk-text-right uk-padding-small" uk-alert>
        <p>${message}</p>
      </div>`;
  };

  const removePastAlert = (parent) => {
    if (parent) {
      const pastAlert = parent.querySelector(".contact-form-alert");
      pastAlert && pastAlert.remove();
      parent
        .querySelector("input, textarea")
        .classList.remove("uk-form-danger");
    }
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

  const handleContactFormDisableSubmit = () => {
    const result = [];
    const form = document.getElementById("contactForm");
    const submit = document.getElementById("contactFormSubmit");

    form.querySelectorAll("input, textarea").forEach((elm) => {
      const regexp = new RegExp(elm.dataset.regexp);
      result.push(
        ...[elm.classList.contains("uk-form-danger"), !regexp.test(elm.value)]
      );
    });

    submit.disabled = result.some((invalid) => invalid);
  };

  const submitContactForm = () => {
    const form = document.getElementById("contactForm");

    form.querySelectorAll(".contact-form-control").forEach((elm) => {
      removePastAlert(elm);
    });

    form.querySelectorAll("input, textarea").forEach((elm) => {
      elm.classList.remove("uk-form-danger");
    });
  };

  const setArticleId = () => {
    const article = document.getElementById("article");
    article.querySelectorAll("h1, h2, h3, h4, h5, h6").forEach((head) => {
      if (!head.id) head.id = encodeURI(head.innerText.replace(/\s/g, "-"));
    });
  };

  const moveToHead = (e) => {
    e.preventDefault();
    const targetId = e.target.href;
    if (targetId) {
      const idStr = targetId.replace(/^.*#/, "");
      const targetElm = document.getElementById(idStr);
      const rect = targetElm.getBoundingClientRect();
      const targetTop = rect.top + window.pageYOffset;
      window.scrollTo({
        top: targetTop,
        left: 0,
        behavior: "smooth",
      });
    }
  };

  const adjustArticleTables = (mediaQuery) => {
    if (mediaQuery.matches) {
      document.querySelectorAll("#article-body > table").forEach((elm) => {
        const responsiveWrapper = document.createElement("div");
        responsiveWrapper.classList.add("uk-overflow-auto");
        responsiveWrapper.appendChild(elm.cloneNode(true));
        elm.parentNode.replaceChild(responsiveWrapper, elm);
      });
    } else {
      document
        .querySelectorAll("#article-body > .uk-overflow-auto > table")
        .forEach((elm) => {
          const responsiveWrapper = elm.parentNode;
          const table = elm.cloneNode(true);
          responsiveWrapper.parentNode.replaceChild(table, responsiveWrapper);
        });
    }
  };

  // Set global methods
  window.__customMethods = {};
  window.__customMethods.setLoadingSpinner = setLoadingSpinner;

  // SetEventListener
  window.addEventListener("DOMContentLoaded", () => {
    const loadingTrigger = document.getElementsByClassName("loading-trigger");
    const contactForm = document.forms.contactForm;
    const article = document.getElementById("article");

    for (let i = 0, len = loadingTrigger.length; i < len; i++)
      loadingTrigger[i].addEventListener("click", setLoadingSpinner);

    if (contactForm) {
      contactForm.querySelectorAll("input, textarea").forEach((elm) => {
        elm.addEventListener("blur", contactFormValidations);
        elm.addEventListener("blur", handleContactFormDisableSubmit);
      });

      contactForm.addEventListener("submit", submitContactForm);
    }

    if (article) {
      setArticleId();
      document.querySelectorAll(".toc-link").forEach((elm) => {
        elm.addEventListener("click", moveToHead);
      });

      adjustArticleTables(mediaQuery_lt_md);

      mediaQuery_lt_md.addListener(adjustArticleTables);
    }
  });
})();
