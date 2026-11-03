document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("note-form");

    if (form) {
        form.addEventListener("submit", function (event) {
            event.preventDefault();
            alert("Your note was added successfully!");
            this.submit();
        });
    }
});