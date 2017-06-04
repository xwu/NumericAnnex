window.jazzy = { 'docset': false };
if (typeof window.dash != 'undefined') {
  document.documentElement.className += ' dash';
  window.jazzy.docset = true;
}
if (navigator.userAgent.match(/xcode/i)) {
  document.documentElement.className += ' xcode';
  window.jazzy.docset = true;
}

// Dumb down quotes within code blocks that delimit strings instead of quotations
// https://github.com/realm/jazzy/issues/714
$("code q").replaceWith(function () {
  return ["\"", $(this).contents(), "\""];
});
