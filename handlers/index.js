const searchCatalog = require('./search-catalog')
const getMeta = require('./get-meta')

module.exports = dependencies => {
    return {
        searchCatalog: searchCatalog(dependencies),
        getMeta: getMeta(dependencies)
    }
}