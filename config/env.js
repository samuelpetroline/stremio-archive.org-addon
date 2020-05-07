require('dotenv').config()

const {
    SEARCH_URL,
    METADATA_URL,
    IMAGE_URL,
    STREAM_URL
} = process.env

const config = {
    addonContentIdPrefix: 'archorg.addon:',
    url: {
        search: SEARCH_URL,
        metadata: METADATA_URL,
        image: IMAGE_URL,
        stream: STREAM_URL,
    }
}

module.exports = Object.freeze(config)
