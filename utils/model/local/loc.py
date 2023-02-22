from geopy.geocoders import Nominatim
from jaseci.actions.live_actions import jaseci_action  # step 1

@jaseci_action(act_group=["location"], allow_remote=True)

def get_details(latitude, longitude):
    geolocator = Nominatim(user_agent="geoapiExercises")
    location = geolocator.reverse(f'{latitude}, {longitude}', exactly_one=True)
    return location
