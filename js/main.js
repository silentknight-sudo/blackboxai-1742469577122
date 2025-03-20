// Main JavaScript file for DriveSure

// Handle mobile menu toggle
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuButton = document.querySelector('.md\\:hidden button');
    const mobileMenu = document.createElement('div');
    mobileMenu.className = 'mobile-menu hidden md:hidden';
    mobileMenu.innerHTML = `
        <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
            <a href="#" class="text-gray-600 hover:text-primary block px-3 py-2 rounded-md text-base font-medium">Home</a>
            <a href="#vehicles" class="text-gray-600 hover:text-primary block px-3 py-2 rounded-md text-base font-medium">Vehicles</a>
            <a href="#" class="text-gray-600 hover:text-primary block px-3 py-2 rounded-md text-base font-medium">About</a>
            <a href="#" class="text-gray-600 hover:text-primary block px-3 py-2 rounded-md text-base font-medium">Contact</a>
            <a href="login.html" class="bg-primary text-white block px-3 py-2 rounded-md text-base font-medium">Login</a>
        </div>
    `;

    if (mobileMenuButton) {
        mobileMenuButton.parentElement.appendChild(mobileMenu);
        mobileMenuButton.addEventListener('click', () => {
            mobileMenu.classList.toggle('hidden');
        });
    }
});

// Handle login form submission
const loginForm = document.querySelector('form');
if (loginForm) {
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const email = document.getElementById('email-address').value;
        const password = document.getElementById('password').value;
        
        // Here you would typically make an API call to your backend
        console.log('Login attempt:', { email, password });
        
        // For demo purposes, simulate a successful login
        alert('Login successful! Redirecting to dashboard...');
        window.location.href = 'dashboard.html';
    });
}

// Handle booking buttons
document.querySelectorAll('button').forEach(button => {
    if (button.textContent.trim() === 'Book Now') {
        button.addEventListener('click', function() {
            // Here you would typically check if user is logged in
            const isLoggedIn = false; // This would be determined by your auth system
            
            if (!isLoggedIn) {
                window.location.href = 'login.html';
            } else {
                // Redirect to booking page
                // window.location.href = 'booking.html';
                alert('Redirecting to booking page...');
            }
        });
    }
});

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const href = this.getAttribute('href');
        if (href !== '#') {
            document.querySelector(href).scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});