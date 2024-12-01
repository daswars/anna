import { initNavigation } from './modules/navigation.js';
import { initIntersectionObservers } from './modules/observers.js';
import { initGallery } from './modules/gallery.js';

document.addEventListener('DOMContentLoaded', () => {
    initNavigation();
    initIntersectionObservers();
    initGallery();
    
    // Check for hash in URL and scroll after content loads
    if (window.location.hash) {
        setTimeout(async () => {
            const element = await waitForElement(window.location.hash);
            if (element) {
                const yOffset = -80;
                const y = element.getBoundingClientRect().top + window.pageYOffset + yOffset;
                window.scrollTo({top: y, behavior: 'smooth'});
            }
        }, 100);
    }
});
