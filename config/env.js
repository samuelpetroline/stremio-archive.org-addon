require('dotenv').config()

const { SEARCH_URL, METADATA_URL, IMAGE_URL, STREAM_URL, PORT } = process.env

const config = {
  port: PORT || 3000,
  addonContentIdPrefix: 'archorg.addon:',
  url: {
    search: SEARCH_URL,
    metadata: METADATA_URL,
    image: IMAGE_URL,
    stream: STREAM_URL,
  },
}

module.exports = Object.freeze(config)
