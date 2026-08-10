(() => {
  const chapters = [...document.querySelectorAll(".artifact-chapter")];
  const links = [...document.querySelectorAll(".story-index a")];

  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      const active = links.find(link => link.hash === `#${entry.target.id}`);
      links.forEach(link => link.classList.toggle("active", link === active));
      active?.scrollIntoView({ behavior: "smooth", block: "nearest", inline: "center" });
    });
  }, { threshold: .55 });

  chapters.forEach(chapter => observer.observe(chapter));
})();
