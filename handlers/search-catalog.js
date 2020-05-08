module.exports = dependencies => {
    const {
        searchCatalog,
        toCatalog,
        validateContentType
    } = dependencies

    return async (args) => {
        try {
            validateContentType(args)

            const items = await searchCatalog({
                search: args.extra.search,
                genre: args.extra.genre,
                skip: args.extra.skip
            })

            return {
                metas: items.map(toCatalog)
            }
        } catch (error) {
            return new Promise.resolve({ metas: [] })
        }
    }
}