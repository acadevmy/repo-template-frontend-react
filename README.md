# Template per repository React

Questo repository template fa uso delle seguenti tecnologie:

- React
- Next.js
- Jest
- Cypress
- Typescript
- Eslint
- Prettier
- Storybook

È strutturato per una singola applicazione frontend (non monorepo).

## Setup

### Automatico

Eseguire lo script interattivo `setup.sh` e seguire le istruzioni.

### Manuale

Il package manager di riferimento è yarn. Se non è presente nel sistema, è dunque necessario installarlo tramite il
seguente comando prima di procedere:

```shell
npm install --global yarn
```

#### PWA

Se si intende utilizzare il modulo `next-pwa` è necessario sostituire il contenuto di `next.config.js`:

```js
/** @type {import('next').NextConfig} */
const withPWA = require('next-pwa');
const runtimeCaching = require('next-pwa/cache');

module.exports = withPWA({
	reactStrictMode: true,
	pwa: {
		dest: 'public',
		runtimeCaching,
	},
});
```

Inoltre, è necessario aggiungere le seguenti dipendenze al `package.json`:

- dependencies
  - `next-pwa: ^5.4.4`
- devDependencies
  - `@babel/core: ^7.17.2`
  - `webpack: ^5.68.0`

#### Installazione e aggiornamento librerie

In seguito, è necessario installare e aggiornare le librerie, in quanto i riferimenti presenti nel `package.json`
potrebbero non puntare alle ultime versioni:

```shell
yarn install
yarn upgrade --latest
```

**ATTENZIONE**: attualmente (12/04/2022) next ha dei problemi con react 18 (il processo richiede di aggiungere i react types anche se già sono installati). Attentendere un aggiornamento di next che risolva il problema, quindi aggiornare manualmente la versione dei packages.

#### File environment

Se necessario, creare un file `.env.local` per le variabili di ambiente da usare in locale:

```shell
touch .env.local
```

Esse potranno essere accedute tramite il consueto `process.env`.

#### Creazione struttura progetto

Creare le cartelle standard di progetto:

```shell
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
```

Alcune potrebbero non essere necessarie. In tale caso, è possibile ometterne la creazione.

#### Disabilitare le regole jsx-a11y

Le regole di accessibilità sono importanti, ma non adatte a tutti i tipi di progetto. Per disattivarle,
creare un file `eslint/a11y-off.js` con il seguente contenuto:

```js
/* eslint-disable */
module.exports = {
	rules: Object.fromEntries(
		Object.keys(require('eslint-plugin-jsx-a11y').rules).map((rule) => [`jsx-a11y/${rule}`, 'off']),
	),
};
```

Inoltre, aggiungere alla configurazione di ESlint presente nel file `.eslintrc.json`, il percorso
`"./eslint/a11y-off.js"` nella sezione `extends` relativa ai soli file typescript (che ha pattern `**/*.+(ts|tsx)`).

## Code style

Il progetto utilizza una combinazione di ESLint e Prettier per il code style, seguendo le regole stabilite
nella [guida alla code quality](https://docs.google.com/document/d/17Mb2oO0DhpehO8r5dWejDhEYjtEhavxumYQD81IpOTY).

## Struttura del progetto

La struttura consigliata del progetto è quello di dividerlo in due cartelle principali, `src`, che contiene
l'applicazione, ed `e2e`, che contiene gli eventuali test end to end. La cartella dell'applicazione `src` è
ulteriormente suddivisa in moduli:

- `api`: comunicazione con il backend.
- `common`: utility e funzioni comuni a più moduli.
- `components`: componenti React.
- `contexts`: context React.
- `hooks`: hook React.
- `layouts`: componenti che definiscono la struttura di una pagina.
- `pages`: componenti pagina. L'alberatura della directory è sfruttata da Next.js per il routing automatico.
- `redux`: tutto ciò che concerne redux.
- `style`: definizioni di stile per l'intera applicazione.

Una o più cartelle possono non essere necessarie per il progetto in questione, in tale caso è possibile semplicemente
cancellarle.

## Creare un nuovo componente

Supponendo di volere scrivere un componente di esempio dal nome `SampleComponent`, ecco i passi da seguire:

1. Creare una cartella `SampleComponent`. Gli import dei componenti devono sempre essere **CamelCase**.
2. Creare un file `SampleComponent.tsx` che contiene l'implementazione del componente.
3. Creare un file `index.ts` che esporta il componente con il seguente contenuto:
   `ts export { default } from './SampleComponent' `
4. Se è necessario modificare lo stile di quel componente specifico, creare un modulo CSS con lo stesso nome del
   componente, nel nostro caso `SampleComponent.module.css`.

Se è presente un design system, il CSS generale va sempre inserito nella cartella `style`.

Componenti usati solo da uno specifico componente possono essere annidati nella subdirectory del componente:
in tale caso è immediatamente chiaro che quel componente non è usato altrove.

## Import resolution

Sono presenti degli import alias typescript per accedere comodamente alle cartelle del progetto. Gli alias hanno lo
stesso nome della cartella cui si riferiscono, preceduta da una `@`: ad esempio, `@e2e` accede alla cartella `e2e`,
mentre `@common` accede alla cartella `src/common`.

## Docker

Per lanciare l'applicazione in docker in locale, è possibile eseguire il comando:

```shell
yarn docker:dev
```

Sono anche disponibili gli script `docker:down` e `docker:sh` che, rispettivamente, chiudono l'applicazione e aprono una
shell dentro il container. La configurazione locale di sviluppo è contenuta nel file `docker-compose.dev.yml`.

L'immagine docker base è `node:lts-alpine`, se tale versione non è idonea al progetto, ricordarsi di cambiarla
appropriatamente.

## Versione di node.js

Il progetto non è vincolato a una versione specifica di node.js. È tuttavia consigliabile partire sempre dall'ultima
LTS, ragione per la quale si è scelto di usare `lts-alpine` come versione di partenza per l'immagine docker.

## Storybook

[Storybook](https://storybook.js.org/) è presente in questo repo template, ed è possibile avviarlo tramite comando:

```
yarn storybook
```

Verrà quindi lanciato sulla porta `6006`
