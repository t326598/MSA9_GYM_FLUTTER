$(function () {
    $(".main-menu li").on("mouseover", function () {
        $(this).find(".sub-menu").stop().slideDown()
    })
    $(".main-menu li").on("mouseout", function () {
        if (!$(this).find(".sub-menu a").hasClass("current")) {
            $(this).find(".sub-menu").stop().slideUp()
        }
    })
})

document.addEventListener("DOMContentLoaded", () => {
    const currentUrl = window.location.pathname;
    const menuLinks = document.querySelectorAll(".sub-menu a");

    menuLinks.forEach(link => {
        if (link.getAttribute("href") === currentUrl) {
            link.classList.add("current");
            link.closest(".sub-menu").style.display = "block";
        }
    });
});