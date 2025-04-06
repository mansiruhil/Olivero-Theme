# Extend the Olivero Theme – Drupal 10:

This project demonstrates how to extend the **Olivero** theme in **Drupal 10**, creating a custom sub theme with personalized styles, layout modifications and additional features while preserving the core functionality of the base theme

## Getting Started:

**1. Clone the Sub theme:**

Clone this repo into your Drupal site's `/themes/custom/` directory:

```bash
cd /web/themes/custom/
git clone https://github.com/your-username/olivero-subtheme.git
```

**2. Enable the Sub theme (Enable it via Drush):**

drush theme:enable olivero-subtheme
drush config:set system.theme default olivero-subtheme


## Customizations:

CSS: Add your styles in css/theme.css.

JS: Add interactive behavior via js/theme.js.

Twig Templates: Override templates for markup changes.

Libraries: Managed in olivero-subtheme.libraries.yml.

## Features:

Fully responsive design

Custom color palette and typography

Modular layout structure

Extendable and lightweight

## Requirements:

Drupal 10+

Olivero Theme (Core)

## Contributors 

[Contributing Guidelines](./CONTRIBUTING.md)

## Code of Conduct 
Please follow our [Code of Conduct](./CODE_OF_CONDUCT.md) to ensure a welcoming environment for everyone.  

## License 
This project is licensed under the [MIT License](./LICENSE).  




