require('dotenv').config()

const {
  SEARCH_URL,
  METADATA_URL
} = process.env

const config = {
  url: {
    search: SEARCH_URL,
    metadata: METADATA_URL
  }
}

module.exports = Object.freeze(config)
