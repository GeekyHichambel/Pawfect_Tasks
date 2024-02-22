import firebase_admin
from firebase_admin import credentials, db, messaging
from datetime import datetime
import schedule
import time
import os
from terminut import printf as print, inputf as input

if os.name == "nt":
    os.system("cls")
else:
    os.system("clear")

cwd = os.getcwd()
cred = credentials.Certificate(os.path.join(cwd, 'pawfecttasks-firebase-adminsdk-uwqy3-0e019a6eac.json'))
firebase_admin.initialize_app(cred, {'databaseURL' : 'https://pawfecttasks-default-rtdb.asia-southeast1.firebasedatabase.app/'})
print('(+) Server is up....')
print('(+) Database connected Successfully.\n\n\n')

def update_task():
    try:
        users_ref = db.reference('pets')
        all_users_ref = db.reference('users')

        if users_ref is None or all_users_ref is None:
            raise ValueError(f'(-) The user reference can\'t be found.\n')

        print('(+) User Reference Set\n')

        for username, user_data in users_ref.get().items():
            pet_status_ref = users_ref.child(username).child('petStatus')

            if pet_status_ref is None:
                raise ValueError(f'(-) The pet_status_ref for user {username} can\'t be found.\n')

            print(f'(+) Pet Status Reference Set for User: {username}')

            if user_data is None:
                raise ValueError(f'(-) The user_data for user {username} can\'t be found.\n')

            for pet_name, pet_stats in pet_status_ref.get().items():

                last_fed = pet_stats.get('lastFed')
                hunger = pet_stats.get('starvation')

                date_format = "%Y-%m-%d %H:%M:%S.%f"
                last_fed_time = datetime.strptime(last_fed, date_format)

                if hunger >= 50:

                    print(f'(*) {pet_name} is hungry.\n')
                    #Pet is Hungry need to send the notification to user and start reducing HP
                    tokens_ref = all_users_ref.child(username).child('fcmTokens')
                    time_difference_hours = None

                    if all_users_ref.child(username).child('last_notification').get() is None:
                        print(f'(-) Last Notification Time not found.')

                    else:
                        last_notification_time = all_users_ref.child(username).child('last_notification').get()
                        date_format = "%Y-%m-%d %H:%M:%S.%f"
                        last_notification_time = datetime.strptime(last_notification_time, date_format)
                        time_difference = datetime.now() - last_notification_time
                        time_difference_hours = int(time_difference.total_seconds() // 3600)

                    if time_difference_hours is None or time_difference_hours >= 6:
                        if tokens_ref.get() is None:
                            print(f'(-) The FCM Tokens reference can\'t be found. Hence Notifications can\'t be sent\n')

                        else:
                            fcm_tokens = tokens_ref.get()

                            if fcm_tokens is None:
                                print(f'(-) No FCM tokens found for {username}. Notifications can\'t be sent.\n')

                            else:
                                message = messaging.MulticastMessage(
                                    notification=messaging.Notification(
                                        title="Your Pet needs you",
                                        body=f'Hi, {username} , {pet_name} is quite hungry and waiting to be fed. Hop on the app to feed him'
                                    ),
                                    tokens=fcm_tokens
                                )

                                response = messaging.send_multicast(message)
                                print(f'(+) Notification sent successfully to {username}. ', response)

                                all_users_ref.child(username).update({'last_notification' : str(datetime.now())})

                    else:
                        print(f'(*) Notification can\'t be sent as the last notification was sent in the last 6 hours\n')


                current_time = datetime.now()
                time_diff = current_time - last_fed_time   

                new_hunger = int(time_diff.total_seconds() // 3600) * 10
                new_hunger = min(max(new_hunger, 0), 100)

                print(f'''(*) Previous hunger: {hunger}
             New hunger: {new_hunger}''')

                if new_hunger == hunger:
                    print('(*) No updates required.\n')
                    continue

                pet_status_ref.child(pet_name).update({'starvation' : new_hunger})

                print(f'(+) Successfully updated the hunger for {pet_name} to {new_hunger}\n\n')

            print(f'(~) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n')

    except Exception as e:
        print(f"(!) Error: {e}")

    finally:
        print('(~) Next cycle after 15 minutes\n\n\n\n')


schedule.every(15).minutes.do(update_task)

update_task()
while True:
    schedule.run_pending()
    time.sleep(1) 
