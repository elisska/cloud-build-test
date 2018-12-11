import datetime
import json
import time
from google.cloud import pubsub_v1
from google.oauth2 import service_account

project_id = "es-s2dl-core-d"
topic_name = "zebra-raw-endpoint"
credentials = service_account.Credentials.from_service_account_file('zebra-pubsub-ingestion-key.json')
publisher = pubsub_v1.PublisherClient(credentials=credentials)
topic_path = publisher.topic_path(project_id, topic_name)

def callback(message_future):
    # When timeout is unspecified, the exception method waits indefinitely.
    if message_future.exception(timeout=30):
        print('Publishing message on {} threw an Exception {}.'.format(
            topic_name, message_future.exception()))
    else:
        print(message_future.result())

for n in range(1, 10):
    ts = time.time()
    et = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
    data = u'{"_o":"owner","_e":"d1","_id":"%d","_et":"%s","_mt":"m1"}' % (n, et)
    # Data must be a bytestring
    data_json = data.encode('utf-8')
    print data_json
    # When you publish a message, the client returns a Future.
    message_future = publisher.publish(topic_path, data_json)
    message_future.add_done_callback(callback)

print('Published message IDs:')

# We must keep the main thread from exiting to allow it to process
# messages in the background.
while True:
    time.sleep(60)
