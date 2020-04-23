const { addonBuilder } = require('stremio-addon-sdk')

// Docs: https://github.com/Stremio/stremio-addon-sdk/blob/master/docs/api/responses/manifest.md
const manifest = {
	'id': 'stremio.archive.org.addon',
	'version': '0.0.1',
	'name': 'Archive.org Movies',
	'description': 'Public domain movies available on Archive.org',
	'resources': ['catalog', 'meta'],
	'types': ['movie'],
	'catalogs': [{
		type: 'movie',
		id: 'archive-org.movies',
		name: 'Archive.org movies',
		extra: [{
			name: 'search',
			isRequired: false
		}, {
			name: 'genre',
			isRequired: false
		}, {
			name: 'skip',
			isRequired: false
		}]
	}]
}

const builder = new addonBuilder(manifest)

module.exports = builder