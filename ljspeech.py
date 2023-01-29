import torchaudio
from speechbrain.pretrained import Tacotron2
from speechbrain.pretrained import HIFIGAN
import simpleaudio

# # Intialize TTS (tacotron2) and Vocoder (HiFIGAN)
# tacotron2 = Tacotron2.from_hparams(source="speechbrain/tts-tacotron2-ljspeech",
#                                    savedir="tmpdir_tts")
# hifi_gan = HIFIGAN.from_hparams(source="speechbrain/tts-hifigan-ljspeech",
#                                 savedir="tmpdir_vocoder")

# # Running the TTS
# mel_output, mel_length, alignment = tacotron2.encode_text(
#     "I just found that my emacs master branch was not compiling with tree-sitter either in ubuntu or msys."
# )

# # Running Vocoder (spectrogram-to-waveform)
# waveforms = hifi_gan.decode_batch(mel_output)

# play_obj = simpleaudio.play_buffer(waveforms.numpy(), 1, 4, 22050)
# play_obj.wait_done()
# # Save the waverform
# torchaudio.save('example_TTS.wav', waveforms.squeeze(1), 22050)


def ljspeech_load():
    tacotron2 = Tacotron2.from_hparams(
        source="speechbrain/tts-tacotron2-ljspeech", savedir="tmpdir_tts")
    hifi_gan = HIFIGAN.from_hparams(source="speechbrain/tts-hifigan-ljspeech",
                                    savedir="tmpdir_vocoder")
    return tacotron2, hifi_gan


def ljspeech_tts(tacotron2,hifi_gan,text_string):
    mel_output, mel_length, alignment = tacotron2.encode_text(text_string)
    waveforms = hifi_gan.decode_batch(mel_output)
    play_obj = simpleaudio.play_buffer(waveforms.numpy(), 1, 4, 22050)
    play_obj.wait_done()
