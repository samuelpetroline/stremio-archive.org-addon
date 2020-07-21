module.exports = (dependencies) => {
  const { env, parseTorrent } = dependencies

  const toCatalog = (item) => {
    return {
      id: `${env.addonContentIdPrefix}${item.identifier}`,
      type: 'movie',
      name: item.title,
      poster: `${env.url.image}/${item.identifier}`,
      description: item.description,
    }
  }

  const toMeta = (item) => {
    return {
      id: item.identifier,
      type: 'movie',
      name: item.title,
      description: item.description,
      language: item.language,
      genres: item.genre ? item.genre.split(',') : undefined,
      director: item.director ? item.director.split(',') : undefined,
    }
  }

  const isTorrent = (file) => file.indexOf('.torrent') !== -1
  const toUrl = (item) => `${env.url.stream}/${item.id}/${item.name}`

  const toSubtitle = (item) => {
    return {
      url: toUrl(item),
      lang: 'eng',
    }
  }

  const toStream = async (item) => {
    const url = toUrl(item)
    const fileIdx = isTorrent(item.name) ? await parseTorrent(url) : undefined

    if (fileIdx) {
      return {
        title: item.format,
        infoHash: item.btih,
        fileIdx,
      }
    }

    return {
      title: item.format,
      url,
    }
  }

  return {
    toCatalog,
    toMeta,
    toStream,
    toSubtitle,
  }
}
