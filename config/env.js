require('dotenv').config()

const {
  SEARCH_URL,
  METADATA_URL,
  IMAGE_URL
} = process.env

const config = {
  url: {
    search: SEARCH_URL,
    metadata: METADATA_URL,
    image: IMAGE_URL
  }
}

module.exports = Object.freeze(config)
