<script>
// Filter long value-label tables as the reader types in their search box
document.querySelectorAll(".value-search").forEach((box) => {
  const input = box.querySelector("input");
  const count = box.querySelector(".value-count");
  const rows = Array.from(box.querySelectorAll("tbody tr"));

  input.addEventListener("input", () => {
    const query = input.value.trim().toLowerCase();
    let shown = 0;
    // match on value or label text
    rows.forEach((row) => {
      const match = row.textContent.toLowerCase().includes(query);
      row.style.display = match ? "" : "none";
      if (match) shown++;
    });
    count.textContent = `Showing ${shown} of ${rows.length}`;
  });
});
</script>
