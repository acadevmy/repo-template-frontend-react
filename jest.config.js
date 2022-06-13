/** @type {import('ts-jest/dist/types').InitialOptionsTsJest} */
module.exports = {
	coverageReporters: ['cobertura'],
	moduleNameMapper: {
		'@api/(.*)': '<rootDir>/src/api/$1',
		'@common/(.*)': '<rootDir>/src/common/$1',
		'@components/(.*)': '<rootDir>/src/components/$1',
		'@contexts/(.*)': '<rootDir>/src/contexts/$1',
		'@hooks/(.*)': '<rootDir>/src/hooks/$1',
		'@layouts/(.*)': '<rootDir>/src/layouts/$1',
		'@pages/(.*)': '<rootDir>/src/pages/$1',
		'@redux/(.*)': '<rootDir>/src/redux/$1',
		'@e2e/(.*)': '<rootDir>/e2e/$1',
	},
	preset: 'ts-jest',
	testEnvironment: 'node',
};
