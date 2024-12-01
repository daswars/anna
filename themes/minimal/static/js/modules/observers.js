export function initIntersectionObservers() {
    initSectionObserver();
    initImageObserver();
}

function initSectionObserver() {
    const sections = document.querySelectorAll('section');
    const navLinks = document.querySelectorAll('.nav-items a'); 
    const header = document.querySelector('.header-section');
    const nav = document.querySelector('.main-nav');

    // Active section tracking
    const observerOptions = {
        root: null,
        rootMargin: '-20% 0px -70% 0px',
        threshold: 0
    };

    const observerCallback = (entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const id = entry.target.id;
                navLinks.forEach(link => {
                    link.classList.remove('active');
                    link.removeAttribute('aria-current');
                    if (link.getAttribute('href') === `#${id}`) {
                        link.classList.add('active');
                        link.setAttribute('aria-current', 'page');
                    }
                });
            }
        });
    };

    const observer = new IntersectionObserver(observerCallback, observerOptions);
    sections.forEach(section => observer.observe(section));

    // Handle home section
    const homeObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                navLinks.forEach(link => {
                    link.classList.remove('active');
                    link.removeAttribute('aria-current');
                    if (link.getAttribute('href') === '#home') {
                        link.classList.add('active');
                        link.setAttribute('aria-current', 'page');
                    }
                });
            }
        });
    }, { threshold: 0.5 });

    const homeSection = document.querySelector('#home');
    if (homeSection) {
        homeObserver.observe(homeSection);
    }

    // Fixed navigation on scroll
    const headerObserver = new IntersectionObserver(
        ([entry]) => {
            if (nav) {
                nav.classList.toggle('nav-fixed', !entry.isIntersecting);
            }
        },
        { threshold: 0 }
    );

    if (header) {
        headerObserver.observe(header);
    }
}

function initImageObserver() {
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                if (!img.src || img.src.includes('data:image')) {
                    img.src = img.dataset.src;
                }
                observer.unobserve(img);
            }
        });
    }, {
        rootMargin: '50px 0px',
        threshold: 0.01
    });

    document.querySelectorAll('img.lazy').forEach(img => {
        imageObserver.observe(img);
    });
}
