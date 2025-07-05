**Extend the Olivero Theme (Drupal 10)**

This project demonstrates how to extend the **Olivero** theme in **Drupal 10**, creating a custom sub theme with personalized styles, layout modifications and additional features while preserving the core functionality of the base theme !

**Getting Started**

*1. Clone the Sub theme*

```bash
cd /web/themes/custom/
git clone https://github.com/your-username/olivero-theme.git
```
*2. Enable the Sub theme (Enable it via Drush)*

drush theme:enable olivero-subtheme

drush config:set system.theme default olivero-subtheme

**Requirements**
- Drupal 10+
- Olivero Theme (Core)

**License**

This project is licensed under the [MIT License](./LICENSE)
