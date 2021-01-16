import UIkit from "uikit";

(() => {
  // variables
  const loadingHtml =
    '<div class="uk-width-expand uk-flex uk-flex-center uk-flex-middle uk-height-small"><div uk-spinner></div></div>';

  const mediaQuery_lt_md = matchMedia("(max-width: 640px)");

  const scrollToTopButtonThreshold = 400;

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

  const toggleToTopButton = (elm) => {
    if (!elm) return;

    const classList = elm.classList;
    if (
      !classList.contains("show") &&
      window.pageYOffset > scrollToTopButtonThreshold
    ) {
      classList.add("show");
    } else if (
      classList.contains("show") &&
      window.pageYOffset <= scrollToTopButtonThreshold
    ) {
      classList.remove("show");
    }
  };

  const formInvalidMessage = (message) => {
    return `\
      <div class="form-alert uk-alert-danger uk-width-1-1 uk-text-right uk-padding-small" uk-alert>
        <p>${message}</p>
      </div>`;
  };

  const removePastAlert = (parent) => {
    if (parent) {
      const pastAlert = parent.querySelector(".form-alert");
      pastAlert && pastAlert.remove();
      parent
        .querySelector("input, textarea")
        .classList.remove("uk-form-danger");
    }
  };

  const formValidations = (e) => {
    const elm = e.target;
    const parent = elm.closest(".validation-target");
    removePastAlert(parent);

    const regexp = new RegExp(elm.dataset.regexp);
    if (!regexp.test(elm.value)) {
      parent.insertAdjacentHTML(
        "beforeend",
        formInvalidMessage(elm.dataset.message)
      );
      UIkit.alert(parent.querySelector(".form-alert"));
      parent.querySelector("input, textarea").classList.add("uk-form-danger");
    }
  };

  const handleFormDisableSubmit = () => {
    const result = [];
    const form = document.querySelector(".validation-form");
    const submit = form.querySelector('input[type="submit"]');

    form.querySelectorAll("input, textarea").forEach((elm) => {
      const regexp = new RegExp(elm.dataset.regexp);
      result.push(
        ...[elm.classList.contains("uk-form-danger"), !regexp.test(elm.value)]
      );
    });

    submit.disabled = result.some((invalid) => invalid);
  };

  const clearFromAlert = () => {
    const form = document.querySelector(".validation-form");

    form.querySelectorAll(".validation-target").forEach((elm) => {
      removePastAlert(elm);
      elm.querySelectorAll("input, textarea").forEach((elm) => {
        elm.classList.remove("uk-form-danger");
      });
    });
  };

  const setArticleId = () => {
    const article = document.getElementById("article");
    article.querySelectorAll("h1, h2, h3, h4, h5, h6").forEach((head) => {
      if (!head.id) head.id = encodeURI(head.innerText.replace(/\s/g, "-"));
    });
  };

  const scrollToElm = (elm, slip) => {
    if (!slip) slip = 0;
    const rect = elm.getBoundingClientRect();
    const targetTop = rect.top + window.pageYOffset + slip;
    window.scrollTo({
      top: targetTop,
      left: 0,
      behavior: "smooth",
    });
  };

  const moveToHead = (e) => {
    e.preventDefault();
    const targetId = e.target.href;
    if (targetId) {
      const idStr = targetId.replace(/^.*#/, "");
      const targetElm = document.getElementById(idStr);
      scrollToElm(targetElm, -20);
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

  const setCommentParent = (e) => {
    e.preventDefault();
    const targetId = e.target.dataset.target;
    if (targetId) {
      const select = document.getElementById("comment-reply-select");
      select.value = targetId;
      scrollToElm(select, -60);
    }
  };

  // Set global methods
  window.__customMethods = {};
  window.__customMethods.setLoadingSpinner = setLoadingSpinner;

  // SetEventListener
  window.addEventListener("turbolinks:load", () => {
    const toTopButton = document.getElementById("to-top-button");
    const loadingTrigger = document.getElementsByClassName("loading-trigger");
    const validationForm = document.querySelector(".validation-form");
    const article = document.getElementById("article");
    const replyLinks = document.querySelectorAll(".reply-to-link");

    toggleToTopButton(toTopButton);

    window.addEventListener("scroll", () => {
      toggleToTopButton(toTopButton);
    });

    for (let i = 0, len = loadingTrigger.length; i < len; i++)
      loadingTrigger[i].addEventListener("click", setLoadingSpinner);

    if (validationForm) {
      validationForm.querySelectorAll("input, textarea").forEach((elm) => {
        elm.addEventListener("blur", formValidations);
        elm.addEventListener("blur", handleFormDisableSubmit);
      });

      validationForm.addEventListener("submit", clearFromAlert);
    }

    if (article) {
      setArticleId();
      document.querySelectorAll(".toc-link").forEach((elm) => {
        elm.addEventListener("click", moveToHead);
      });

      adjustArticleTables(mediaQuery_lt_md);

      mediaQuery_lt_md.addListener(adjustArticleTables);

      replyLinks &&
        replyLinks.forEach((elm) => {
          elm.addEventListener("click", setCommentParent);
        });
    }
  });
})();
