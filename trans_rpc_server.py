# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""The Python implementation of the GRPC Trans server."""

from concurrent import futures
import logging

import grpc
import trans_rpc_pb2
import trans_rpc_pb2_grpc

import warnings

warnings.filterwarnings("ignore")

from transformers import AutoTokenizer, MarianMTModel

import ljspeech


def model_load(src, trg):
    model_name = f"../opus-mt-{src}-{trg}"
    model = MarianMTModel.from_pretrained(model_name)
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    return model, tokenizer


def trans_str(model, tokenizer, text):
    batch = tokenizer([text], return_tensors="pt")
    generated_ids = model.generate(**batch)
    return tokenizer.batch_decode(generated_ids, skip_special_tokens=True)[0]


class Trans(trans_rpc_pb2_grpc.TransServicer):

    model_zh_en, token_zh_en = model_load("zh", "en")
    model_en_zh, token_en_zh = model_load("en", "zh")
    tacotron2_tts_en, hifi_gan_tts_en = ljspeech.ljspeech_load()

    def SayHello(self, request, context):
        return trans_rpc_pb2.RpcReply(message='Hello, %s!' % request.name)

    def SayHello2(self, request, context):
        return trans_rpc_pb2.RpcReply(message='Hello2, %s!' % request.name)

    def TransZh(self, request, context):
        message1 = trans_str(self.model_zh_en, self.token_zh_en, request.name)
        return trans_rpc_pb2.RpcReply(message=message1)

    def TransEn(self, request, context):
        message1 = trans_str(self.model_en_zh, self.token_en_zh, request.name)
        return trans_rpc_pb2.RpcReply(message=message1)

    def TtsEn(self, request, context):
        ljspeech.ljspeech_tts(self.tacotron2_tts_en, self.hifi_gan_tts_en, request.name)
        return trans_rpc_pb2.RpcReply(message="message")

def serve():
    port = '50051'
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    trans_rpc_pb2_grpc.add_TransServicer_to_server(Trans(), server)
    server.add_insecure_port('[::]:' + port)
    server.start()
    print("Server started, listening on " + port)
    server.wait_for_termination()


if __name__ == '__main__':
    logging.basicConfig()
    serve()
