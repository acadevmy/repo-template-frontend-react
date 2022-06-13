import type { AppProps } from 'next/app';
import type { VFC } from 'react';

const App: VFC<AppProps> = ({ Component, pageProps }) => {
	// eslint-disable-next-line react/jsx-props-no-spreading
	return <Component {...pageProps} />;
};

export default App;
