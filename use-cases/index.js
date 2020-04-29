const Catalog = require('./catalog')
const Meta = require('./meta')

module.exports = dependencies => {
    return {
        ...Catalog({
            ...dependencies
        }),
        ...Meta({
            ...dependencies
        })
    }
}