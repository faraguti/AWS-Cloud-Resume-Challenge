/*!
* Start Bootstrap - Resume v7.0.6 (https://startbootstrap.com/theme/resume)
* Copyright 2013-2023 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-resume/blob/master/LICENSE)
*/
//
// Scripts
// 

window.addEventListener('DOMContentLoaded', event => {

    // Activate Bootstrap scrollspy on the main nav element
    const sideNav = document.body.querySelector('#sideNav');
    if (sideNav) {
        new bootstrap.ScrollSpy(document.body, {
            target: '#sideNav',
            rootMargin: '0px 0px -40%',
        });
    };

    // Collapse responsive navbar when toggler is visible
    const navbarToggler = document.body.querySelector('.navbar-toggler');
    const responsiveNavItems = [].slice.call(
        document.querySelectorAll('#navbarResponsive .nav-link')
    );
    responsiveNavItems.map(function (responsiveNavItem) {
        responsiveNavItem.addEventListener('click', () => {
            if (window.getComputedStyle(navbarToggler).display !== 'none') {
                navbarToggler.click();
            }
        });
    });

});

// // JavaScript Counter
// const counter = document.querySelector(".counter-number");
// async function updateCounter() {
//     let response = await fetch("https://o34ezkdwsb.execute-api.us-west-2.amazonaws.com/cloud-resume-challenge-function");
//     let data = await response.json();
//     counter.innerHTML = `${data}`;
// }

// updateCounter();


// JavaScript Counter
const counter = document.querySelector(".counter-number");
async function updateCounter() {
    try {
        const response = await fetch("https://ck0oj70heh.execute-api.us-west-2.amazonaws.com/cloud-resume-function");

        if (response.ok) {
            const data = await response.json();
            counter.innerHTML = `${data}`;
        } else {
            console.error("Failed to update counter:", response.statusText);
        }
    } catch (error) {
        console.error("An error occurred:", error);
    }
}

updateCounter();
