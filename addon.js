const { addonBuilder } = require('stremio-addon-sdk')

module.exports = (dependencies) => {
  const { env } = dependencies

  // Docs: https://github.com/Stremio/stremio-addon-sdk/blob/master/docs/api/responses/manifest.md
  const manifest = {
    id: 'stremio.archive.org.addon',
    version: '1.1.0',
    name: 'Archive.org Movies',
    description: 'Public domain movies available on Archive.org',
    resources: [
      'catalog',
      {
        name: 'meta',
        types: ['movie'],
        idPrefixes: [env.addonContentIdPrefix],
      },
      {
        name: 'stream',
        types: ['movie'],
      },
    ],
    types: ['movie'],
    catalogs: [
      {
        type: 'movie',
        id: 'archive-org.movies',
        name: 'Archive.org movies',
        extra: [
          {
            name: 'search',
            isRequired: false,
          },
          {
            name: 'genre',
            isRequired: false,
            options: [
              'Drama',
              'Comedy',
              'Crime',
              'Mystery',
              'Western',
              'Romance',
              'Thriller',
              'Horror',
              'Adventure',
              'Action',
              'Silent',
              'War',
              'Film Noir',
              'Sci-Fi',
              'Musical',
            ],
          },
          {
            name: 'skip',
            isRequired: false,
          },
        ],
      },
    ],
  }

  return new addonBuilder(manifest)
}
