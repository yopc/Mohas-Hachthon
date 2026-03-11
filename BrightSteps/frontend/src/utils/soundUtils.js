import * as Tone from 'tone';

/**
 * Play a simple success sound
 */
export const playSuccessSound = async () => {
  await Tone.start();
  const synth = new Tone.Synth().toDestination();
  synth.triggerAttackRelease('C5', '0.1');
  setTimeout(() => {
    synth.triggerAttackRelease('E5', '0.1');
  }, 100);
  setTimeout(() => {
    synth.triggerAttackRelease('G5', '0.2');
  }, 200);
};

/**
 * Play an error/wrong sound
 */
export const playErrorSound = async () => {
  await Tone.start();
  const synth = new Tone.Synth().toDestination();
  synth.triggerAttackRelease('G3', '0.2');
  setTimeout(() => {
    synth.triggerAttackRelease('D3', '0.3');
  }, 150);
};

/**
 * Play a celebration sound
 */
export const playCelebrationSound = async () => {
  await Tone.start();
  const synth = new Tone.Synth().toDestination();
  const notes = ['C4', 'E4', 'G4', 'C5', 'G4', 'E4', 'C4', 'G4', 'C5'];
  notes.forEach((note, index) => {
    setTimeout(() => {
      synth.triggerAttackRelease(note, '0.1');
    }, index * 80);
  });
};

/**
 * Play a click sound
 */
export const playClickSound = async () => {
  await Tone.start();
  const synth = new Tone.Synth().toDestination();
  synth.triggerAttackRelease('C4', '0.05');
};

/**
 * Play animal sounds
 */
export const animalSounds = {
  dog: () => playAnimalSound(['E4', 'E4'], [0.2, 0.2]),
  cat: () => playAnimalSound(['A4', 'A4', 'A4'], [0.1, 0.1, 0.2]),
  lion: () => playAnimalSound(['G2', 'F2', 'E2'], [0.3, 0.3, 0.5]),
  cow: () => playAnimalSound(['C3', 'C3'], [0.5, 0.5]),
  sheep: () => playAnimalSound(['F4', 'F4'], [0.2, 0.2]),
  bird: () => playAnimalSound(['C5', 'E5', 'G5', 'E5'], [0.1, 0.1, 0.1, 0.1]),
};

const playAnimalSound = async (notes, durations) => {
  await Tone.start();
  const synth = new Tone.Synth().toDestination();
  let delay = 0;
  notes.forEach((note, index) => {
    setTimeout(() => {
      synth.triggerAttackRelease(note, durations[index]);
    }, delay);
    delay += durations[index] * 1000 + 100;
  });
};

/**
 * Play background music for games (simple melody)
 */
export const playBackgroundMusic = async (stop = false) => {
  if (stop) {
    Tone.Transport.stop();
    return;
  }
  
  await Tone.start();
  const synth = new Tone.PolySynth(Tone.Synth).toDestination();
  synth.volume.value = -20; // Quiet background music
  
  const melody = [
    { note: 'C4', duration: '4n' },
    { note: 'E4', duration: '4n' },
    { note: 'G4', duration: '4n' },
    { note: 'A4', duration: '4n' },
    { note: 'G4', duration: '4n' },
    { note: 'E4', duration: '4n' },
    { note: 'C4', duration: '2n' },
  ];
  
  let time = 0;
  melody.forEach(({ note, duration }) => {
    setTimeout(() => {
      synth.triggerAttackRelease(note, duration);
    }, time);
    time += Tone.Time(duration).toMilliseconds();
  });
};

/**
 * Text-to-speech helper (browser native)
 */
export const speak = (text, options = {}) => {
  if ('speechSynthesis' in window) {
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.rate = options.rate || 0.9;
    utterance.pitch = options.pitch || 1.1;
    utterance.volume = options.volume || 1;
    window.speechSynthesis.speak(utterance);
  }
};

export default {
  playSuccessSound,
  playErrorSound,
  playCelebrationSound,
  playClickSound,
  animalSounds,
  playBackgroundMusic,
  speak,
};

