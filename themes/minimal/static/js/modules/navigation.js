export function initNavigation() {
    initMobileMenu();
    initNavGroups();
    initSmoothScrolling();
    initKeyboardNavigation();
}

function initMobileMenu() {
    const menuToggle = document.querySelector('.menu-toggle');
    const nav = document.querySelector('.main-nav');
    const body = document.body;

    menuToggle?.addEventListener('click', () => {
        const isExpanded = menuToggle.getAttribute('aria-expanded') === 'true';
        toggleMenu(!isExpanded);
    });

    function toggleMenu(show) {
        menuToggle?.setAttribute('aria-expanded', show);
        menuToggle?.setAttribute('aria-label', show ? 'Menü schließen' : 'Menü öffnen');
        menuToggle?.classList.toggle('active', show);
        nav?.classList.toggle('active', show);
        body.classList.toggle('menu-open', show);
    }

    // Export for reuse
    window.toggleMenu = toggleMenu;
}

function initNavGroups() {
    document.querySelectorAll('.nav-group-toggle').forEach(button => {
        button.addEventListener('click', (e) => {
            const isExpanded = button.getAttribute('aria-expanded') === 'true';
            toggleNavGroup(button, !isExpanded);
        });
    });

    // Close groups when clicking outside
    document.addEventListener('click', (e) => {
        document.querySelectorAll('.nav-group.active').forEach(group => {
            if (!group.contains(e.target)) {
                const button = group.querySelector('.nav-group-toggle');
                toggleNavGroup(button, false);
            }
        });
    });
}

function toggleNavGroup(button, show) {
    const content = button.nextElementSibling;
    const group = button.closest('.nav-group');
    
    button.setAttribute('aria-expanded', show);
    if (content) content.hidden = !show;
    group?.classList.toggle('active', show);
}

async function waitForElement(selector) {
    return new Promise(resolve => {
        if (document.querySelector(selector)) {
            return resolve(document.querySelector(selector));
        }

        const observer = new MutationObserver(mutations => {
            if (document.querySelector(selector)) {
                observer.disconnect();
                resolve(document.querySelector(selector));
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    });
}

function initSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', async function (e) {
            e.preventDefault();
            const href = this.getAttribute('href');
            
            // Immediate attempt to find the element
            let section = document.querySelector(href);
            
            // If not found, wait for it
            if (!section) {
                section = await waitForElement(href);
            }
            
            if (section) {
                // Load all lazy images in the target section
                const lazyImages = section.querySelectorAll('img.lazy');
                lazyImages.forEach(img => {
                    if (!img.src || img.src.includes('data:image')) {
                        img.src = img.dataset.src;
                    }
                });

                // Wait for all images to load
                const images = section.getElementsByTagName('img');
                const imagePromises = Array.from(images).map(img => {
                    if (img.complete) return Promise.resolve();
                    return new Promise(resolve => {
                        img.onload = resolve;
                        img.onerror = resolve;
                    });
                });

                // Wait for all images to load
                Promise.all(imagePromises).then(() => {
                    requestAnimationFrame(() => {
                        const yOffset = -80;
                        const y = section.getBoundingClientRect().top + window.pageYOffset + yOffset;
                        
                        window.scrollTo({
                            top: y,
                            behavior: 'smooth'
                        });
                    });

                    // Close mobile menu and nav groups
                    window.toggleMenu?.(false);
                    document.querySelectorAll('.nav-group.active').forEach(group => {
                        const button = group.querySelector('.nav-group-toggle');
                        toggleNavGroup(button, false);
                    });
                });
            }
        });
    });
}

function initKeyboardNavigation() {
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            window.toggleMenu?.(false);
            document.querySelectorAll('.nav-group.active').forEach(group => {
                const button = group.querySelector('.nav-group-toggle');
                toggleNavGroup(button, false);
            });
        }
    });
}
