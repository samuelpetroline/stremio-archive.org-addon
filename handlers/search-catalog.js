module.exports = ({ searchCatalog }) => {
    (args) => {
        if (args.type === 'movie') {
            return searchCatalog({
                search: args.extra.search,
                genre: args.extra.genre,
                skip: args.extra.skip
            })
        }

        return new Promise.resolve({ metas: [] })
    }
}