/* Collapse Quarto code blocks on article pages.
   pkgdown post-processing can strip the <details> that code-fold:true
   produces, so we re-wrap every .sourceCode block that isn't already
   inside a <details> element. */
document.addEventListener("DOMContentLoaded", function () {
  if (!window.location.pathname.includes("/articles/")) return;
  document.querySelectorAll(".sourceCode").forEach(function (div) {
    if (div.closest("details")) return;
    var details = document.createElement("details");
    var summary = document.createElement("summary");
    summary.className = "code-summary";
    summary.textContent = "Show code";
    details.appendChild(summary);
    div.parentNode.insertBefore(details, div);
    details.appendChild(div);
  });
});
