# Drupal 10 Olivero sub theme

__Note__: This will be obsolete with Drupal 11.x, see
[Allow starterkit theme generator tool to clone Olivero](https://www.drupal.org/project/drupal/issues/3301173)

Minimal template to create a sub theme from [Drupal Olivero theme](https://www.drupal.org/project/olivero).

This is only recommended if you want to make **minor tweaks** and understand that Olivero could break your
modifications as it changes.

## Quick HowTo: 

Copy this theme in your Drupal theme folder `web/themes/custom` and rename it, ie `olivero_sub_theme` > `_MY_THEME_NAME_`.

Rename all files in this folder from `olivero_sub_theme` > `_MY_THEME_NAME_`.

Edit `_MY_THEME_NAME_.info.yml` with your informations.

Edit `_MY_THEME_NAME_.theme` to change `olivero_sub_theme_css_alter` > `MY_THEME_NAME_css_alter` and change the theme
name `olivero_sub_theme` with your name.

Run:

```bash
scripts/build.sh
```

Enable the theme as usual from your Drupal.

Visit theme settings to set base colors: `Administration > Appearance > Appearance settings > _MY_THEME_NAME_`

Disable css, js aggregation and cache in Drupal, see the [Drupal documentation](https://www.drupal.org/docs/develop/development-tools/disable-caching).

Adapt [css/theme.css](./css/theme.css) and [js/theme.js](./js/theme.js).

Build the css with postcss by running each time:

```bash
scripts/build.sh
```
