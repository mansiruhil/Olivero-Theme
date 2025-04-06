#!/usr/bin/env bash
#
# Generate and copy Drupal Olivero css and fonts to our theme for minimal override.
#
# You can customize your theme by editing:
# - css/variables.pcss.css
# - css/theme.css
# - js/theme.js
# Then run this script each time to compile your changes.

set -eu

__red=$'\e[1;31m'
__grn=$'\e[1;32m'
__blu=$'\e[0;34m'

get_abs_path() {
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

find_up () {
  path="$1"
  while [[ "$path" != "" && ! -e "$path/$2" ]]; do
    path=${path%/*}
  done
  echo "$path"
}

_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_web_root="web"
_drupal_root="$(find_up "$_DIR" "web")"
if [ -z "${_drupal_root}" ]; then
  _drupal_root="$(find_up "$_DIR" "docroot")"
  _web_root="docroot"
  if [ -z "${_drupal_root}" ]; then
    echo -e "${__red}[ERROR]\e[0m Can not find Drupal root, do you have 'web' or 'docroot'?"
    exit 1
  fi
fi

_my_sub_theme="$(basename $(dirname "$_DIR"))"

_drupal_core="${_drupal_root}/${_web_root}/core"
_drupal_core_olivero="${_drupal_root}/${_web_root}/core/themes/olivero"
_my_sub_theme_path="${_drupal_root}/${_web_root}/themes/custom/${_my_sub_theme}"

_error=0

if [ ! -d "${_drupal_core}" ]; then
  _drupal_core="$_DIR/../../../../../${_drupal_core}"
  if [ ! -d "${_drupal_core}" ]; then
    _drupal_core="$_DIR/../../../../${_drupal_core}"
    [ ! -d "${_drupal_core}" ] && echo -e "${__red}[ERROR]\e[0m Drupal core missing: '$(get_abs_path "$_drupal_core")'!" && _error=1
  fi
fi

if [ ! -d "${_drupal_core_olivero}" ]; then
  _drupal_core_olivero="$_DIR/../../../../core/themes/olivero"
  [ ! -d "${_drupal_core_olivero}" ] && echo -e "${__red}[ERROR]\e[0m Olivero theme missing: '$(get_abs_path "$_drupal_core_olivero")'" && _error=1
fi

if [ ! -d "${_my_sub_theme_path}" ]; then
  _my_sub_theme_path="${_drupal_root}/${_web_root}/themes/${_my_sub_theme}"
  if [ ! -d "${_my_sub_theme_path}" ]; then
    [ ! -d "${_my_sub_theme_path}" ] && echo -e "${__red}[ERROR]\e[0m Sub theme missing, did you create/copy this subtheme in '$(get_abs_path "$_my_sub_theme_path")'?" && _error=1
  fi
fi

if ! command -v node >/dev/null 2>&1; then
  echo -e "${__red}[ERROR]\e[0m Node is required for this script!"
  _error=1
fi

_pkg_manager='yarn'

if ! command -v yarn >/dev/null 2>&1; then
  echo -e "${__blu}[Notice]\e[0m Yarn not found, fallback to NPM."
  _pkg_manager='npm'
  if ! command -v npm >/dev/null 2>&1; then
    echo -e "${__red}[ERROR]\e[0m NPM is required to build the theme, please install to use this script."
    exit 1
  fi
fi

[ "${_error}" == 1 ] && exit 1

echo -e "${__blu}[Notice]\e[0m Start building the theme..."

_drupal_core="$(get_abs_path "$_drupal_core")"
_drupal_core_olivero="$(get_abs_path "$_drupal_core_olivero")"
_my_sub_theme_path="$(get_abs_path "$_my_sub_theme_path")"

if [ ! -d "${_drupal_core}/node_modules" ]; then
  echo -e "${__blu}[Notice]\e[0m One time install of Drupal packages with ${_pkg_manager}..."
  if [ ${_pkg_manager} == 'yarn' ]; then
    yarn --cwd "${_drupal_core}" install
  else
    npm --prefix "${_drupal_core}" install
  fi
fi

if [ -d "${_drupal_core_olivero}/css.orig/" ]; then
  rm -rf "${_drupal_core_olivero}/css.orig/"
fi

cp -r "${_drupal_core_olivero}/css/" "${_drupal_core_olivero}/css.orig/"
cp -f "${_my_sub_theme_path}/css/variables.pcss.css" "${_drupal_core_olivero}/css/base/variables.pcss.css"

cmd="node ${_drupal_core}/scripts/css/postcss-build.js"
while IFS= read -r file; do
  cmd+=" --file $file"
done < <(find ${_drupal_core_olivero}/css -type f -name '*.pcss.css')
eval $cmd >/dev/null 2>&1

# Copy the result of build.
mv "${_my_sub_theme_path}/css/theme.css" "${_my_sub_theme_path}/theme.css"
mv "${_my_sub_theme_path}/css/variables.pcss.css" "${_my_sub_theme_path}/variables.pcss.css"
rm -rf "${_my_sub_theme_path}/css/"
mkdir -p "${_my_sub_theme_path}/css/"
mv "${_my_sub_theme_path}/theme.css" "${_my_sub_theme_path}/css/theme.css"
mv "${_my_sub_theme_path}/variables.pcss.css" "${_my_sub_theme_path}/css/variables.pcss.css"

cp -r "${_drupal_core_olivero}/css" "${_my_sub_theme_path}/"
cp -r "${_drupal_core_olivero}/fonts" "${_my_sub_theme_path}/"
rm -f "${_my_sub_theme_path}/css/**/*.pcss.css"

# Set back Olivero files.
rm -rf "${_drupal_core_olivero}/css/"
mv "${_drupal_core_olivero}/css.orig/" "${_drupal_core_olivero}/css/"

echo -e "${__grn}[Success]\e[0m Olivero Sub theme ${_my_sub_theme} built successfully"
