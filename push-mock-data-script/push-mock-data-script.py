import time
import logging
import argparse
import datetime
import json
import random
import ast
from google.cloud import pubsub

SAMPLE_MESSAGES_INPUT = './sample_messages.txt'

def publish(publisher, topic, events):
   numobs = len(events)
   if numobs > 0:
       logging.info('Publishing {0} messages into ''{1}'' topic  timestamp: {2}'.format(numobs, topic, datetime.datetime.utcnow()))
       for event_data in events:
           publisher.publish(topic, (str(event_data).replace('\'','\"')).encode('utf-8')) # data being published to Pub/Sub must be sent as a bytestring

def simulate(sample_messages_list, topic, chunk_size, speed_time_fraction, total_numb_of_messages): # numb of messages per second
 
    chunk_start_time = datetime.datetime.utcnow()
    topublish = list() 
    
    # pick-up and enrich random massage sample
    def get_message(sm_list):
        message = random.choice(sm_list) 
        message['_m']['_id'] = i
        message['_m']['_et'] = datetime.datetime.now().isoformat()
        return message
    
    # sleep computation
    def compute_sleep_secs(numb_of_messages_sent):
        time_elapsed = (datetime.datetime.utcnow() - chunk_start_time).seconds
        to_sleep_secs = (speed_time_fraction / chunk_size * numb_of_messages_sent) - time_elapsed
        logging.info('It took {} seconds for the chunk'.format(time_elapsed))
        return to_sleep_secs

    for i in range(total_numb_of_messages):
        
        topublish.append(get_message(sample_messages_list))
        if (len(topublish) >= chunk_size):
            publish(publisher, topic, topublish) # notify accumulated messages

            # how much time should we sleep? (notification takes a while)
            to_sleep_secs = compute_sleep_secs(len(topublish))
            if to_sleep_secs > 0:
                logging.info('Sleeping {} seconds'.format(to_sleep_secs))
                time.sleep(to_sleep_secs)            

            topublish = list() # empty out list
            chunk_start_time = datetime.datetime.utcnow() # reset start time for chunk
        
    # left-over records; notify again
    publish(publisher, topic, topublish) # notify accumulated messages

        
if __name__ == '__main__':
   parser = argparse.ArgumentParser(description='Send sample messages to Cloud Pub/Sub in small groups, simulating real-time behavior')
   parser.add_argument('--chunkSize', help='Example: 10 implies 10 messages will be sent to Cloud Pub/Sub in (--speedTimeFraction) seconds; '
                                           '0.5 implies 1 message will be sent to Cloud Pub/Sub in (--speedTimeFraction * 2) seconds', required=True, type=float)
   parser.add_argument('--speedTimeFraction', help='(OPTIONAL: default = 1) Example: --speedTimeFraction 1 implies (--chunkSize) messages will be sent to Cloud Pub/Sub in 1 second', required=False, type=int, default=1)                                                        
   parser.add_argument('--totalMessagesToSend', help='(OPTIONAL: default = 100) Example: --totalMessagesToSend 1000 implies 1000 messages will be send to Cloud Pub/Sub in total', required=False, type=int, default=10)                                                      
   parser.add_argument('--project', help='Example: --project $DEVSHELL_PROJECT_ID', required=True)
   parser.add_argument('--topic', help='Example: --topic my_pubsub_topic', required=True)
   args = parser.parse_args()

   # create Pub/Sub notification topic
   logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)
   publisher = pubsub.PublisherClient()
   topic_path = publisher.topic_path(args.project, args.topic)
   sample_messages_list = list()
   
   try:
      publisher.get_topic(topic_path)
      logging.info('Reusing pub/sub topic {}'.format(args.topic))
   except:
      publisher.create_topic(topic_path)
      logging.info('Creating pub/sub topic {}'.format(args.topic))
   
   # read file with sample messages
   with open(SAMPLE_MESSAGES_INPUT, 'r') as sm:
      for line in sm:
           sample_messages_list.append(ast.literal_eval(line)) # make a sample messages list

   simulate(sample_messages_list, topic_path, args.chunkSize, args.speedTimeFraction, args.totalMessagesToSend)
