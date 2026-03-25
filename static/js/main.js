/**
 * main.js – Wed n Feast Core Client Logic
 */

document.addEventListener('DOMContentLoaded', () => {

    // 1. Mobile Navigation Toggle
    const navToggle = document.getElementById('navToggle');
    const navLinks = document.getElementById('navLinks');
    
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            
            // Animate hamburger to X (basic implementation)
            const spans = navToggle.querySelectorAll('span');
            if (navLinks.classList.contains('active')) {
                spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
                spans[1].style.opacity = '0';
                spans[2].style.transform = 'rotate(-45deg) translate(7px, -8px)';
            } else {
                spans[0].style.transform = 'none';
                spans[1].style.opacity = '1';
                spans[2].style.transform = 'none';
            }
        });
    }

    // 2. Sticky Navbar scroll effect
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // 3. Auto-hide flash messages after 5 seconds
    const flashes = document.querySelectorAll('.flash');
    flashes.forEach(flash => {
        setTimeout(() => {
            if (flash.parentElement) {
                flash.style.opacity = '0';
                flash.style.transform = 'translateX(50px)';
                flash.style.transition = 'all 0.4s ease';
                setTimeout(() => flash.remove(), 400);
            }
        }, 5000);
    });

    // 4. Typing effect word cycling (Hero Section)
    const typingSpan = document.querySelector('.typing-text');
    if (typingSpan) {
        const words = ['Celebration', 'Wedding', 'Reception', 'Event'];
        let wordIndex = 0;

        // Change word every 6s (Syncs roughly with CSS alternate animation)
        setInterval(() => {
            wordIndex = (wordIndex + 1) % words.length;
            // Briefly hide during backspace phase
            setTimeout(() => {
                typingSpan.textContent = words[wordIndex];
            }, 1000); 
        }, 6000);
    }
});
