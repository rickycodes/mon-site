define({
	proxyPort: 9999,
	proxyUrl: 'http://localhost/',

	capabilities: {
		'selenium-version': '2.41.0'
	},

	environments: [
		{
			browserName: [
				'chrome',
				'firefox'
			]
		}
	],

	maxConcurrency: 3,

	functionalSuites: [ 'tests/functional/navigation' ],

	excludeInstrumentation: /^(?:tests|node_modules)\//
});
