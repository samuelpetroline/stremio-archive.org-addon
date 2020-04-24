module.exports = dependencies => {
    const {
        searchCatalog
    } = dependencies

    return async (args) => {
        if (args.type === 'movie') {
            return {
                metas: searchCatalog({
                    search: args.extra.search,
                    genre: args.extra.genre,
                    skip: args.extra.skip
                })
            }
        }

        return new Promise.resolve({ metas: [] })
    }
}