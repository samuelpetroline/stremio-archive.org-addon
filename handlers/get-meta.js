module.exports = dependencies => {
    const {
        getMeta,
        toMeta,
        env
    } = dependencies

    return async (args) => {
        if (args.type === 'movie' && args.id.indexOf(env.addonContentIdPrefix) !== -1) {
            const meta = await getMeta({
                id: args.id.replace(env.addonContentIdPrefix, '')
            })

            return {
                meta: toMeta(meta)
            }
        }

        return Promise.resolve({ meta: {} })
    }
}