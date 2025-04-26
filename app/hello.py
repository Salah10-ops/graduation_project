#import redis
#from redis.exceptions import ConnectionError
#import tornado.ioloop
#import tornado.web
#
#import os
#from sys import exit
#
#
#try:
#
#    redis_host = os.getenv("REDIS_HOST", "localhost")
#    r = redis.Redis(
#        host=redis_host,
#        port=6379,
#        db=0
#    )
#    r.set("counter", 0)
#except ConnectionError:
#    print("Redis server isn't running. Exiting...")
#    exit()
#
#
#environment = os.getenv("ENVIRONMENT", "****")  # default to DEV if not passed
#port = 8000
#
#
#class MainHandler(tornado.web.RequestHandler): 
#    def get(self):
#        self.render(
#            "index.html",
#             dict={"environment": environment,  "counter":r.incr("counter", 1)},
#        )
#
#
#class Application(tornado.web.Application):
#    def __init__(self):
#        handlers = [(r"/", MainHandler)]
#        settings = {
#            "template_path": os.path.join(
#                os.path.dirname(os.path.abspath(__file__)), "templates"
#            ),
#            "static_path": os.path.join(
#                os.path.dirname(os.path.abspath(__file__)), "static"
#            ),
#        }
#        tornado.web.Application.__init__(self, handlers, **settings)
#
#
#if __name__ == "__main__":
#    app = Application()
#    app.listen(port)
#    print("App running: http://localhost:8000")
#    tornado.ioloop.IOLoop.current().start()
import os
from sys import exit

import redis
from redis.exceptions import ConnectionError
import tornado.ioloop
import tornado.web

from prometheus_client import start_http_server, Counter

# 🔧 Prometheus: Start metrics server on port 8001
start_http_server(8001)

# 📊 Define Prometheus counter
REQUEST_COUNTER = Counter('python_app_requests_total', 'Total HTTP requests')

# 🌐 Connect to Redis
try:
    redis_host = os.getenv("REDIS_HOST", "localhost")
    r = redis.Redis(host=redis_host, port=6379, db=0)
    r.set("counter", 0)
except ConnectionError:
    print("Redis server isn't running. Exiting...")
    exit()

# 🌎 App environment config
environment = os.getenv("ENVIRONMENT", "DEV")
port = 8000


# 🧠 Main Request Handler
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        REQUEST_COUNTER.inc()  # 🔥 Prometheus metric increment
        self.render(
            "index.html",
            dict={"environment": environment, "counter": r.incr("counter", 1)},
        )


# 🚀 Tornado App Setup
class Application(tornado.web.Application):
    def __init__(self):
        handlers = [(r"/", MainHandler)]
        settings = {
            "template_path": os.path.join(
                os.path.dirname(os.path.abspath(__file__)), "templates"
            ),
            "static_path": os.path.join(
                os.path.dirname(os.path.abspath(__file__)), "static"
            ),
        }
        super().__init__(handlers, **settings)


if __name__ == "__main__":
    app = Application()
    app.listen(port, address="0.0.0.0")  # Listen on all interfaces
    print(f"App running at http://0.0.0.0:{port}")
    tornado.ioloop.IOLoop.current().start()
