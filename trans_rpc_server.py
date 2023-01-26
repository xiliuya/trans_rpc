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
"""The Python implementation of the GRPC helloworld.Trans server."""

from concurrent import futures
import logging

import grpc
import trans_rpc_pb2
import trans_rpc_pb2_grpc


class Trans(trans_rpc_pb2_grpc.TransServicer):

    def SayHello(self, request, context):
        return trans_rpc_pb2.RpcReply(message='Hello, %s!' % request.name)

    def SayHello2(self, request, context):
        return trans_rpc_pb2.RpcReply(message='Hello2, %s!' % request.name)

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
