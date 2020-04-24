const searchCatalog = require('./search-catalog')

module.exports = dependencies => {
    return {
        searchCatalog: searchCatalog(dependencies)
    }
}