#!/bin/sh

# Formatting

reset="\033[0m"
bold="\033[1m"
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
cyan="\033[36m"

devmy="${bold}${yellow}.${reset}${bold}dev${reset}my"
info="${bold}${cyan}i${reset}"
question="${bold}${green}?${reset}"
error="${bold}${red}✗${reset}"

# Configuration files content

file_a11yoff="/* eslint-disable */
module.exports = {
	rules: Object.fromEntries(
		Object.keys(require('eslint-plugin-jsx-a11y').rules)
			.map((rule) => [\`jsx-a11y/\${rule}\`, 'off']),
	),
};"

file_next_config="/** @type {import('next').NextConfig} */
module.exports = {
	reactStrictMode: true,
};"

file_next_config_pwa="/** @type {import('next').NextConfig} */
const withPWA = require('next-pwa');
const runtimeCaching = require('next-pwa/cache');

module.exports = withPWA({
	reactStrictMode: true,
	pwa: {
		dest: 'public',
		runtimeCaching,
	},
});"

echo
echo "$devmy repository setup"
echo

if ! which npm >/dev/null; then
	echo "$error Node.js not present, please install it before continuing."
	echo
	exit 1
fi

if ! which yarn >/dev/null; then
	printf "%b yarn is not present in your system, and is required. Do you want to install it globally now? (Y/n) " "$question"
	read -r choice
	if [ "$choice" = y ] || [ "$choice" = Y ] || [ -z "$choice" ]; then
		npm install --global yarn
		echo
	else
		echo "$error In order to proceed, yarn must be installed globally."
		echo
		exit 1
	fi
fi

printf "%b Do you want to build a Progressive Web App (PWA)? (y/N) " "$question"
read -r choice
if [ "$choice" = n ] || [ "$choice" = N ] || [ -z "$choice" ]; then
	if grep -q 'next-pwa' package.json; then
		perl -i -0pe 's|"next-pwa":\s*".*?",?\s*||gms' package.json
	fi
	if grep -q '@babel/core' package.json; then
		perl -i -0pe 's|"\@babel/core":\s*".*?",?\s*||gms' package.json
	fi
	if grep -q 'webpack' package.json; then
		perl -i -0pe 's|,?\s*"webpack":\s*".*?"||gms' package.json
	fi
	echo "$file_next_config" >next.config.js
	echo "$info Not using the PWA module."
	echo
else
	if ! grep -q 'next-pwa' package.json; then
		perl -i -0pe 's|("next":\s*".*?")(,?\s*)|$1,\n\t\t"next-pwa": "^5.4.4"$2|gms' package.json
	fi
	if ! grep -q '@babel/core' package.json; then
		perl -i -0pe 's|("devDependencies":\s*{)|$1\n\t\t"\@babel/core": "^7.17.2",|gms' package.json
	fi
	if ! grep -q 'webpack' package.json; then
		perl -i -0pe 's|("typescript":\s*".*?")(,?)|$1,\n\t\t"webpack": "^5.68.0"$2|gms' package.json
	fi
	echo "$file_next_config_pwa" >next.config.js
	echo "$info Using the PWA module."
	echo
fi

echo "$info Installing dependencies."
yarn install
echo

printf "%b Do you want to update your dependencies to their latest version? (Y/n) " "$question"
read -r choice
if [ "$choice" = y ] || [ "$choice" = Y ] || [ -z "$choice" ]; then
	yarn upgrade --latest
	echo
else
	echo "$info Dependencies not updated, please make sure that package.json is using the appropriate versions."
	echo
fi

if [ -f .env.local ]; then
	printf "%b An .env.local file is already present. Do you want to replace it? (y/N) " "$question"
	read -r choice
	if [ "$choice" = n ] || [ "$choice" = N ] || [ -z "$choice" ]; then
		echo "$info .env.local file not replaced."
		echo
	else
		touch .env.local
		if [ -f .env.local ]; then
			echo "$info .env.local file replaced successfully."
			echo
		else
			echo "$error Unable to replace .env.local file"
			echo
			exit 1
		fi
	fi
else
	printf "%b Do you want to create an .env.local file (Y/n) " "$question"
	read -r choice
	if [ "$choice" = y ] || [ "$choice" = Y ] || [ -z "$choice" ]; then
		touch .env.local
		if [ -f .env.local ]; then
			echo "$info .env.local file created successfully."
			echo
		else
			echo "$error Unable to create .env.local file"
			echo
			exit 1
		fi
	else
		echo "$info .env.local file not created, local environment variables are not being used."
		echo
	fi
fi

echo "$info Creating folder structure."
mkdir -p src/api
mkdir -p src/common
mkdir -p src/components
mkdir -p src/contexts
mkdir -p src/hooks
mkdir -p src/layouts
mkdir -p src/pages
mkdir -p src/redux
mkdir -p src/style
mkdir -p e2e
echo

printf "%b Do you want to disable accessibility ESLint rules? (y/N) " "$question"
read -r choice
if [ "$choice" = n ] || [ "$choice" = N ] || [ -z "$choice" ]; then
	rm -f eslint/a11y-off.js
	rmdir eslint 2>/dev/null
	if grep -q 'eslint/a11y-off' .eslintrc.json; then
		perl -i -0pe 's|,?\s*"./eslint/a11y-off.js"||gms' .eslintrc.json
	fi
	echo "$info Accessibility ESLint rules retained."
	echo
else
	mkdir -p eslint
	echo "$file_a11yoff" >'eslint/a11y-off.js'
	if ! grep -q 'eslint/a11y-off' .eslintrc.json; then
		perl -i -0pe 's|("extends":\s*\[[\s\S]*?)(\s*],)|$1,\n\t\t\t\t"./eslint/a11y-off.js"$2|ms' .eslintrc.json
	fi
	echo "$info Accessibility ESLint rules disabled."
	echo
fi

printf "%b Do you want to remove the .git folder so you can start a new repository? (y/N) " "$question"
read -r choice
if [ "$choice" = n ] || [ "$choice" = N ] || [ -z "$choice" ]; then
	echo "$info .git folder retained, remember to delete it before starting a new repository."
	echo
else
	rm -rf .git
	echo "$info .git folder removed."
	echo
fi

echo "${info} Setup finished."
echo
echo "${info} You can delete this setup file by typing ${bold}rm setup.sh${reset}."
echo
