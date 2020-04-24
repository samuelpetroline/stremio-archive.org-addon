const Catalog = dependencies => {
    const {
        httpClient,
        queryBuilder,
        env
    } = dependencies

    const searchCatalog = async (request) => {
        const {
            search,
            genre,
            skip
        } = request

        try {
            const query = queryBuilder({
                search: search ? `${search}*` : null,
                genre
            })

            console.log(query)

            return []
        } catch (error) {
            throw error
        }

    }

    return {
        searchCatalog
    }
}

module.exports = Catalog