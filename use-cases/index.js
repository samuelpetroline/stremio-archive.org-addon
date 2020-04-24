const Catalog = require('./catalog')

module.exports = dependencies => {
    return {
        ...Catalog({
            ...dependencies
        })
    }
}