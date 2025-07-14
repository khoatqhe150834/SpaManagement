/**
 * Tailwind CSS Configuration for Spa Management System
 * This file contains the custom Tailwind configuration
 */

// Configure Tailwind CSS with custom theme
if (typeof tailwind !== 'undefined') {
    tailwind.config = {
        theme: {
            extend: {
                colors: {
                    primary: "#D4AF37",
                    "primary-dark": "#B8941F",
                    secondary: "#FADADD",
                    "spa-cream": "#FFF8F0",
                    "spa-dark": "#333333",
                },
                fontFamily: {
                    serif: ["Playfair Display", "serif"],
                    sans: ["Roboto", "sans-serif"],
                },
            },
        },
    };
}
