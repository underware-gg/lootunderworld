import React from 'react'
import Link from 'next/link'
import { Image } from 'semantic-ui-react'
import { useAsciiText, deltaCorpsPriest1 } from 'react-ascii-text'
import App from '@/underworld/components/App'
// import SplashArt from '@/underworld/components/SplashArt'

export default function IndexPage() {
  //@ts-ignore
  const textStyle: UseAsciiTextArgs = {
    animationCharacters: "▒ ░ █",
    animationDirection: "down",
    animationInterval: 0,
    animationLoop: false,
    animationSpeed: 20,
    font: deltaCorpsPriest1,
  }
  const Text1Ref = useAsciiText({
    ...textStyle,
    text: [" ", "LooT"],
  });
  const Text2Ref = useAsciiText({
    ...textStyle,
    text: [" ", "Underworld"],
  });

  return (
    <App>
      {/* @ts-ignore */}
      <pre ref={Text1Ref}></pre>
      {/* @ts-ignore */}
      <pre ref={Text2Ref}></pre>

      <div className='Spacer20' />
      <h2><button onClick={() => { location.href = '/underworld/' }}>ENTER</button></h2>

      <div className='Spacer20' />
      <h2><button onClick={() => { location.href = '/editor/' }}>BITMAP EDITOR</button></h2>

      <br />
      <div className='Spacer20' />
      <a href='/test/'>test page</a>
    </App>
  );
}


