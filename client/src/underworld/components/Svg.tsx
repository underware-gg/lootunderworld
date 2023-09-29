
function Svg({
  content,
  className = '',
}: any) {
  //@ts-ignore
  return <embed className={className} src={content ? `data:image/svg+xml,${content}` : null} type='image/svg+xml' />
  // return <img className={className} src={content ? `data:image/svg+xml,${content}` : null} />
}

export default Svg
