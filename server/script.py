import firebase_admin
from firebase_admin import credentials, db, messaging
from datetime import datetime, timedelta
import schedule
import time
import os
import pytz
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

def update_hunger():
    try:
        users_ref = db.reference('pets')
        all_users_ref = db.reference('users')

        if users_ref is None or all_users_ref is None:
            raise ValueError(f'(-) The user reference can\'t be found.\n')

        print('(+) User Reference Set\n')

        for username, user_data in users_ref.get().items():
            pet_status_ref = users_ref.child(username).child('petStatus')
            pet_ref = users_ref.child(username)
            pet_data = pet_ref.get()

            if pet_status_ref is None:
                raise ValueError(f'(-) The pet_status_ref for user {username} can\'t be found.\n')

            print(f'(+) Pet Status Reference Set for User: {username}')

            if user_data is None:
                raise ValueError(f'(-) The user_data for user {username} can\'t be found.\n')

            for pet_name, pet_stats in pet_status_ref.get().items():

                health = pet_stats.get('health')
                last_fed = pet_stats.get('lastFed')
                hunger = pet_stats.get('starvation')
                last_hunger = pet_stats.get('lastHunger')
                nickname = pet_stats.get('nickname')
                date_format = "%Y-%m-%d %H:%M:%S.%f%z"
                last_fed_time = datetime.strptime(last_fed, date_format)
                time_difference_hours = None

                if hunger >= 50:

                    print(f'(*) {pet_name} is hungry.\n')
                    #Pet is Hungry need to send the notification to user and start reducing HP
                    tokens_ref = all_users_ref.child(username).child('fcmTokens')
                    time_difference = None

                    if all_users_ref.child(username).child('stats').child('last_notification').get() is None:
                        print(f'(-) Last Notification Time not found.')

                    else:
                        last_notification_time = all_users_ref.child(username).child('stats').child('last_notification').get()
                        date_format = "%Y-%m-%d %H:%M:%S.%f%z"
                        last_notification_time = datetime.strptime(last_notification_time, date_format)
                        time_difference = datetime.now(pytz.timezone('Asia/Kolkata')) - last_notification_time
                        time_difference_hours = int(time_difference.total_seconds() // 3600)

                    if time_difference_hours is None or time_difference_hours >= 6:
                        if tokens_ref.get() is None:
                            print(f'(-) The FCM Tokens reference can\'t be found. Hence Notifications can\'t be sent\n')

                        else:
                            fcm_tokens = tokens_ref.get()

                            if fcm_tokens is None:
                                print(f'(-) No FCM tokens found for {username}. Notifications can\'t be sent.\n')

                            else:
                                title = ''
                                body = ''

                                if hunger >= 50 and health > 0:
                                    title = "Your Pet needs you!!"
                                    body = f'Hi, {username}.\n{nickname} is quite hungry and waiting to be fed. Hop on the app to feed him'

                                elif health == 0:
                                    title = "Shame on you!!"
                                    body = f"Hi, {username}.\nYour laziness resulted in the death of poor {nickname}.\nR.I.P ⚰️ {nickname}"

                                message = messaging.MulticastMessage(
                                     notification=messaging.Notification(
                                        title=title,
                                        body=body,
                                    ),
                                    tokens=fcm_tokens
                                )

                                response = messaging.send_multicast(message)
                                print(f'(+) Notification sent successfully to {username}. ', response)

                                all_users_ref.child(username).child('stats').update({'last_notification' : str(datetime.now(pytz.timezone('Asia/Kolkata')))})

                    else:
                        print(f'(*) Notification can\'t be sent as the last notification was sent in the last 6 hours')
                        time_left = timedelta(hours=6) - time_difference
                        print(f'(*) Time left for next notification: {time_left}\n')




                current_time = datetime.now(pytz.timezone('Asia/Kolkata'))
                time_diff = current_time - last_fed_time

                new_hunger = int(time_diff.total_seconds() // 3600) * 10
                new_hunger += last_hunger
                new_hunger = min(max(new_hunger, 0), 100)

                print(f'''(*) Previous hunger: {hunger}
                New hunger: {new_hunger}''')

                if new_hunger == hunger:
                    print('(*) No updates required.\n')
                    if hunger == 100:
                        update_hp(pet_ref, pet_data, pet_status_ref, pet_stats, pet_name, time_diff.total_seconds())
                    continue

                pet_status_ref.child(pet_name).update({'starvation' : new_hunger})

                print(f'(+) Successfully updated the hunger for {pet_name} to {new_hunger}\n\n')

            print(f'(~) - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n')

    except Exception as e:
        print(f"(!) Error: {e}")

    finally:
        print('(~) Next updation cycle after 15 minutes\n')
        print(f'(~) > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > < < < < < < < < < < < < < < < < < < < < < < < < < < < < < <\n\n\n')


def update_hp(pet_ref, pet_data, petStatsRef, petStats, pet_name, timeDifference):
    try:
        timeDifferenceHours = int(timeDifference // 3600)
        timeDifferenceHours -= 10

        hp = petStats.get('health')
        new_hp = int((timeDifferenceHours // 2) * 10)
        new_hp = 100 - new_hp
        new_hp = min(max(new_hp, 0), 100)

        if hp == new_hp:
            print(f'(*) No need to update hp\n')
            return

        if new_hp == 0:
            pets_died = pet_data.get('petsDied')
            pet_ref.update({'petsDied' : pets_died + 1})

        petStatsRef.child(pet_name).update({'health' : new_hp})
        print(f'(+) Successfully updated the hp for {pet_name} to {new_hp}\n\n')


    except Exception as e:
        print(f'Exception {e}')


def last_user_online():
    try:
        users_ref = db.reference('users')

        if users_ref is None:
            raise ValueError(f'(-) The users reference can\'t be found.\n')

        print(f'(+) Users reference set\n')

        for username, user_data in users_ref.get().items():
            stats_ref = users_ref.child(username).child('stats')

            if stats_ref is None:
                print(f'(-) Stats for the user : {username} can\'t be found\n')

            else:
                print(f'(+) Stats Reference Set for User: {username}\n')

                if stats_ref.child('last_online').get() is None:
                    print(f'(-) Last online time can\'t be found for the User: {username}\n')

                else:
                    last_online = stats_ref.child('last_online').get()
                    date_format = "%Y-%m-%d %H:%M:%S.%f%z"
                    last_online_time = datetime.strptime(last_online, date_format)
                    tokens_ref = users_ref.child(username).child('fcmTokens')
                    time_difference = datetime.now(pytz.timezone('Asia/Kolkata')) - last_online_time
                    time_difference_hours = int(time_difference.total_seconds() // 3600)

                    if time_difference_hours >= 24:
                        if tokens_ref is None:
                            print(f'(-) Tokens ref can\'t be found.\n')

                        else:
                            fcm_tokens = tokens_ref.get()

                            if fcm_tokens is None:
                                print(f'(-) FCM tokens not found for User: {username}\n')

                            else:
                                message = messaging.MulticastMessage(
                                    notification=messaging.Notification(
                                        title="Long time no see 😯",
                                        body=f'Hi, {username}.\nIts been so long since you last came online. Don\'t get swayed away by distractions, get back on track ASAP.'
                                    ),
                                    tokens=fcm_tokens
                                )

                                response = messaging.send_multicast(message)
                                print(f'(+) Notification sent successfully to {username}. ', response)

                    else:
                        print(f'(~) Notification can\'t be sent as the user was online in last 24 hours.\n')

    except Exception as e:
        print(f"(!) Error: {e}")

    finally:
        print('(~) Next user check online cycle after 4 hours.\n')
        print(f'(~) > > > > > > > > > > > > > > > > > > > > > > > > > > > > > > < < < < < < < < < < < < < < < < < < < < < < < < < < < < < <\n\n\n')




schedule.every(15).minutes.do(update_hunger)
schedule.every(4).hours.do(last_user_online)

update_hunger()
last_user_online()

while True:
    schedule.run_pending()
    time.sleep(1)