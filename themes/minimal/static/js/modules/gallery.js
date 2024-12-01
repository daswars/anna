export function initGallery() {
    const artworks = document.querySelectorAll('.artwork');
    let currentIndex = 0;
    let isGalleryMode = false;

    artworks.forEach((artwork, index) => {
        artwork.addEventListener('click', () => {
            currentIndex = index;
            openGallery(artwork.closest('.artwork-grid'), index);
        });
    });

    document.addEventListener('keydown', (e) => {
        if (!isGalleryMode) return;
        
        switch(e.key) {
            case 'Escape':
                closeGallery();
                break;
            case 'ArrowLeft':
                navigateGallery('prev');
                break;
            case 'ArrowRight':
                navigateGallery('next');
                break;
        }
    });

    function openGallery(grid, index) {
        isGalleryMode = true;
        grid.classList.add('gallery-mode');
        document.body.style.overflow = 'hidden';
        showArtwork(index);
    }

    function closeGallery() {
        isGalleryMode = false;
        const grid = document.querySelector('.artwork-grid.gallery-mode');
        if (grid) {
            grid.classList.remove('gallery-mode');
            document.body.style.overflow = '';
        }
    }

    function navigateGallery(direction) {
        const artworksArray = Array.from(artworks);
        if (direction === 'prev') {
            currentIndex = (currentIndex - 1 + artworksArray.length) % artworksArray.length;
        } else {
            currentIndex = (currentIndex + 1) % artworksArray.length;
        }
        showArtwork(currentIndex);
    }

    function showArtwork(index) {
        const artwork = artworks[index];
        if (artwork) {
            const grid = artwork.closest('.artwork-grid');
            grid.innerHTML = '';
            grid.appendChild(artwork.cloneNode(true));
        }
    }
}
