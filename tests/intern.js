define({
	proxyPort: 9999,
	proxyUrl: 'http://localhost:9999/',

	capabilities: {
		'selenium-version': '2.41.0'
	},
	environments: [
		{ browserName: 'firefox' }
	],

	maxConcurrency: 3,

	// Functional test suite(s) to run in each browser once non-functional tests are completed
	functionalSuites: [ 'tests/functional/hashupdate' ],

	// A regular expression matching URLs to files that should not be included in code coverage analysis
	excludeInstrumentation: /^(?:tests|node_modules)\//
});
