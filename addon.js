const { addonBuilder } = require("stremio-addon-sdk")

// Docs: https://github.com/Stremio/stremio-addon-sdk/blob/master/docs/api/responses/manifest.md
const manifest = {
	"id": "community.Archiveorg",
	"version": "0.0.1",
	"catalogs": [],
	"resources": [],
	"types": [],
	"name": "Archive.org Movies",
	"description": "Public domain movies available on Archive.org"
}
const builder = new addonBuilder(manifest)

module.exports = builder.getInterface()