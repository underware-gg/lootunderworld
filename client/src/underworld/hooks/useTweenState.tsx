// Hook for tween state
// from: https://gist.github.com/SevenOutman/438aca96d4cc05f1a81ffe07a98ea99d
// Usage:
//   const [tweenState, setTweenState] = useTweenState(0, 700)
//   setTweenState(1000) // tweenState gradually changes to 1000 in 700ms
// 

import { useCallback, useEffect, useRef, useState } from 'react'


const useAnimationFrame = ({
  nextAnimationFrameHandler = (timeFraction: number) => {},
  duration = Number.POSITIVE_INFINITY,
  shouldAnimate = true
}) => {
  const frame = useRef(0);
  const firstFrameTime = useRef(performance.now());

  const animate = (now:number) => {
    // calculate at what time fraction we are currently of whole time of animation
    let timeFraction = (now - firstFrameTime.current) / duration;
    if (timeFraction > 1) {
      timeFraction = 1;
    }

    if (timeFraction <= 1) {
      nextAnimationFrameHandler(timeFraction);

      // request next frame only in cases when we not reached 100% of duration
      if (timeFraction != 1) frame.current = requestAnimationFrame(animate);
    }
  };

  useEffect(() => {
    if (shouldAnimate) {
      firstFrameTime.current = performance.now();
      frame.current = requestAnimationFrame(animate);
    } else {
      cancelAnimationFrame(frame.current);
    }
    return () => cancelAnimationFrame(frame.current);
  }, [shouldAnimate]);
};









export default function useTweenState(initialValue: number, duration: number, easingFunction = easeInOutQuad) {
  const [state, setState] = useState(initialValue)
  const [runningTween, setRunningTween] = useState(false)

  const now = Date.now()

  const startValue = useRef(state)
  const targetValue = useRef(state)
  const startTime = useRef(now)

  const setTargetValue = useCallback((target: number) => {
    if (target !== state) {
      startValue.current = state
      targetValue.current = target
      startTime.current = now
      setRunningTween(true)
    } else {
      setRunningTween(false)
    }
  }, [])

  useEffect(() => {
    setTargetValue(initialValue)
  }, [initialValue])

  useEffect(() => {
    if (runningTween) {
      const dt = now - startTime.current
      if (dt >= duration) {
        setState(targetValue.current)
        setRunningTween(false)
      } else {
        setState(easingFunction(dt / duration) * (targetValue.current - startValue.current) + startValue.current)
      }
    }
  }, [runningTween, now])

  return [state, setTargetValue]
}

// @see https://gist.github.com/gre/1650294
export function linear(t: number): number {
  return t
}

export function easeInQuad(t: number): number {
  return t * t
}

export function easeOutQuad(t: number): number {
  return t * (2 - t)
}

export function easeInOutQuad(t: number): number {
  return t < .5 ? 2 * t * t : -1 + (4 - 2 * t) * t
}

export function easeInCubic(t: number): number {
  return t * t * t
}

export function easeOutCubic(t: number): number {
  return (--t) * t * t + 1
}

export function easeInOutCubic(t: number): number {
  return t < .5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
}

export function easeInQuart(t: number): number {
  return t * t * t * t
}

export function easeOutQuart(t: number): number {
  return 1 - (--t) * t * t * t
}

export function easeInOutQuart(t: number): number {
  return t < .5 ? 8 * t * t * t * t : 1 - 8 * (--t) * t * t * t
}

export function easeInQuint(t: number): number {
  return t * t * t * t * t
}

export function easeOutQuint(t: number): number {
  return 1 + (--t) * t * t * t * t
}

export function easeInOutQuint(t: number): number {
  return t < .5 ? 16 * t * t * t * t * t : 1 + 16 * (--t) * t * t * t * t
}
