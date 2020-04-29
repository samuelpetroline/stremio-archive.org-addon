const Catalog = dependencies => {
    const {
        httpClient,
        queryBuilder,
        env
    } = dependencies

    // https://archive.org/advancedsearch.php?q=collection%3A%28feature_films%29+AND+mediatype%3A%28movies%29&fl%5B%5D=avg_rating&fl%5B%5D=description&fl%5B%5D=genre&fl%5B%5D=headerImage&fl%5B%5D=identifier&fl%5B%5D=publicdate&fl%5B%5D=rights&fl%5B%5D=subject&fl%5B%5D=title&sort%5B%5D=&sort%5B%5D=&sort%5B%5D=&rows=50&page=1&output=json

    const searchCatalog = async (request) => {
        const {
            search,
            genre,
            skip
        } = request

        try {
            const query = queryBuilder({
                collection: 'feature_films',
                mediatype: 'movies',
                search: search ? `${search}*` : null,
                subject: genre
            })

            const response = await httpClient.get(env.url.search, {
                params: {
                    count: (+skip || 0) + 100,
                    sorts: 'num_reviews desc,avg_rating desc',
                    fields: 'avg_rating,creator,date,description,genre,identifier,language,subject,title,type',
                    q: query
                }
            })

            console.log(response)

            return response.data.items
        } catch (error) {
            return []
        }
    }

    return {
        searchCatalog
    }
}

module.exports = Catalog