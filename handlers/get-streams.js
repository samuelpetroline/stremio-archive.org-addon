module.exports = (dependencies) => {
  const { getStreams, toStream, toSubtitle, validateContentType, env } =
    dependencies

  return async (args) => {
    try {
      validateContentType(args)

      const id = args.id.replace(env.addonContentIdPrefix, '')
      const { streams, subtitles } = await getStreams({ id })
      const parsedSubtitles = subtitles.map(toSubtitle)

      return {
        streams: await Promise.all(
          streams.map((stream) =>
            toStream({
              id,
              subtitles: parsedSubtitles,
              ...stream,
            }),
          ),
        ),
      }
    } catch (error) {
      return Promise.resolve({ streams: [] })
    }
  }
}
