(function () {
  var root = document.documentElement;
  var idle = null;
  function reveal() {
    root.classList.add('sb-active');
    clearTimeout(idle);
    idle = setTimeout(function () {
      root.classList.remove('sb-active');
    }, 800);
  }
  document.addEventListener('scroll', reveal, { capture: true, passive: true });
  document.addEventListener('wheel', reveal, { passive: true });
  document.addEventListener('touchmove', reveal, { passive: true });
})();