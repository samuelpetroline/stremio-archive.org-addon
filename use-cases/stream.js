const Stream = (dependencies) => {
  const { httpClient, env } = dependencies

  const getStreams = async (request) => {
    const { id } = request

    const response = await httpClient.get(`${env.url.metadata}/${id}/files`)

    return extractStreams({ id, result: response.data.result })
  }

  // Returns only streams supported by Stremio
  const extractStreams = ({ id, result }) => {
    const streams = []
    const subtitles = []

    for (const file of result) {
      if (file.name.match(`${id}(.*)(.mp4|.torrent)`)) {
        streams.push(file)
      }

      if (file.name.match(`${id}(.*)(.srt)`)) {
        subtitles.push(file)
      }
    }

    return {
      streams,
      subtitles,
    }
  }

  return {
    getStreams,
  }
}

module.exports = Stream
