const createRequestPayload = (fields, photo) => {
  const boundary = 'uploading photos'
  const multipartRequestHeaders = [
    ['Content-Type', `multipart/related; boundary="${boundary}"`],
    ['Authorization', `Bearer ${fields.token}`]
  ]
  const delimiter = "\r\n--" + boundary + "\r\n"
  const close_delim = "\r\n--" + boundary + "--"
  const contentType = fields.content_type
  const metadata = {
    'name': fields.name,
    'mimeType': contentType,
    'parents': [fields.parent]
  }

  const base64Data = btoa(photo)
  const multipartRequestBody =
    delimiter +
    'Content-Type: application/json; charset=UTF-8\r\n\r\n' +
    JSON.stringify(metadata) +
    delimiter +
    'Content-Type: ' + contentType + '\r\n' +
    'Content-Transfer-Encoding: base64\r\n' +
    '\r\n' +
    base64Data +
    close_delim

  return {
    multipartRequestHeaders,
    multipartRequestBody
  }
}

const setPhotosIds = ids => {
  const x = document.getElementById("photos-ids")
  x.value = ids.join(',')
}

export const uploadPhotos = (entries, onViewError) => {
  let ids = []

  entries.forEach(entry => {
    const { file, meta: { url, fields } } = entry

    const reader = new FileReader()

    reader.readAsBinaryString(file)
    reader.onload = () => {
      const {
        multipartRequestHeaders,
        multipartRequestBody
      } = createRequestPayload(fields, reader.result)

      const xhr = new XMLHttpRequest()
      onViewError(() => xhr.abort())

      xhr.onprogress = event => {
        if (event.lengthComputable) {
          const percent = Math.round((event.loaded / event.total) * 100)
          entry.progress(percent)
        }
      }

      xhr.open("POST", url, true)
      multipartRequestHeaders.map(([key, value]) => {
        xhr.setRequestHeader(key, value)
      })

      xhr.send(multipartRequestBody)

      xhr.onload = () => {
        if (xhr.status !== 200) return entry.error()
        const response = JSON.parse(xhr.response)
        if (response.id) {
          ids = [response.id, ...ids]
        }
      }
      xhr.onerror = () => entry.error()
    }
  })

  setPhotosIds(ids)
}