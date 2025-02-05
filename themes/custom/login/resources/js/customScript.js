window.onload = function () {
    const socialProviders = document.getElementById('kc-social-providers');
    const ul = socialProviders.firstElementChild;
    for (let li of ul.children) {
        // e.g. "social-diamond"
        const parts = li.firstElementChild.id.split('-');
        const alias = parts[1];
        const highlight = parts.length > 2 && parts[parts.length - 1] === 'highlight';
        if (alias === 'diamond' || highlight) {
            li.classList.add('highlight', 'pf-v5-c-button', 'pf-m-primary', 'pf-m-block');
            li.addEventListener('click', () => {
                li.querySelector('a').click();
            });
        }
    }

    document.querySelector('.pf-v5-c-login__main-footer-band').addEventListener('click', () => {
        document.querySelector('.pf-v5-c-login__main-body').classList.toggle('hidden');
    });
};
