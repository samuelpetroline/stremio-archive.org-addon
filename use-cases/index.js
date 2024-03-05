const Catalog = require('./catalog')
const Meta = require('./meta')
const Stream = require('./stream')

module.exports = (dependencies) => {
  return {
    ...Catalog({
      ...dependencies,
    }),
    ...Meta({
      ...dependencies,
    }),
    ...Stream({
      ...dependencies,
    }),
  }
}
