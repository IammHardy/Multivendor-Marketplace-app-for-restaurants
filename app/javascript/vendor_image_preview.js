document.addEventListener("DOMContentLoaded", () => {
  const profileInput = document.getElementById("profile_image_input");
  const bannerInput  = document.getElementById("banner_image_input");

  const profilePreview = document.getElementById("profile_image_preview");
  const bannerPreview  = document.getElementById("banner_image_preview");

  if (profileInput) {
    profileInput.addEventListener("change", (e) => {
      const file = e.target.files[0];
      if (file) {
        profilePreview.src = URL.createObjectURL(file);
      }
    });
  }

  if (bannerInput) {
    bannerInput.addEventListener("change", (e) => {
      const file = e.target.files[0];
      if (file) {
        bannerPreview.src = URL.createObjectURL(file);
      }
    });
  }
});
