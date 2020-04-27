module.exports = dependencies => {
    const {
        searchCatalog,
        toCatalog
    } = dependencies

    return async (args) => {
        if (args.type === 'movie') {

            const items = await searchCatalog({
                search: args.extra.search,
                genre: args.extra.genre,
                skip: args.extra.skip
            })

            return {
                metas: items.map(toCatalog)
            }
        }

        return new Promise.resolve({ metas: [] })
    }
}