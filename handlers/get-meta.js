module.exports = dependencies => {
    const {
        getMeta,
        toMeta,
        validateRequest,
        validateContentType,
        env
    } = dependencies

    return async (args) => {
        try {
            validateRequest(args)
            validateContentType(args)

            const meta = await getMeta({
                id: args.id.replace(env.addonContentIdPrefix, '')
            })

            return {
                meta: toMeta(meta)
            }
        } catch (error) {
            return Promise.resolve({ meta: {} })
        }

    }
}