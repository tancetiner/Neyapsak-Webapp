from collections import UserDict
import json

from django.db import models
from django.db.models.query import QuerySet
from rest_framework import serializers, status, generics
from rest_framework.response import Response


from .serializers import (
    BuyTicketSerializer,
    EventSerializer,
    CreateEventSerializer,
    SearchEventSerializer,
    SaveEventSerializer,
)
from rest_framework.views import APIView
import re
import random

from .models import events, manages, saves, buys


def generateID():
    return random.randint(1, 999999)


headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": True,
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Accept": "application/json; charset=UTF-8",
}

# Create your views here.
class eventList(APIView):
    serializer_class = EventSerializer
    lookup_url_word = "sorted"
    lookup_email_word = "email"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        sortBy = request.GET.get(self.lookup_url_word)
        email = request.GET.get(self.lookup_email_word)

        if sortBy == None:
            eventList = events.objects.all()
            eventDataList = []
            for event in eventList:
                eventData = EventSerializer(event).data
                eventData["isSaved"] = (
                    len(saves.objects.filter(email=email, eventID=event.eventID)) != 0
                )
                eventData["isBought"] = (
                    len(buys.objects.filter(email=email, eventID=event.eventID)) != 0
                )
                eventDataList.append(eventData)

            if len(eventDataList) == 0:
                return Response(
                    {"Error": "Invalid request"}, status=status.HTTP_404_NOT_FOUND
                )

            return Response(eventDataList, status=status.HTTP_200_OK)

        elif sortBy == "date":
            eventList = events.objects.order_by("date")
            eventDataList = [EventSerializer(event).data for event in eventList]
            return Response(eventDataList, status=status.HTTP_200_OK)

        elif sortBy == "minPrice":
            eventList = events.objects.order_by("minPrice", "-maxPrice")
            eventDataList = [EventSerializer(event).data for event in eventList]
            return Response(eventDataList, status=status.HTTP_200_OK)

        elif sortBy == "maxPrice":
            eventList = events.objects.order_by("maxPrice", "minPrice")
            eventDataList = [EventSerializer(event).data for event in eventList]
            return Response(eventDataList, status=status.HTTP_200_OK)

        elif sortBy == "type":
            eventList = events.objects.order_by("type")
            eventDataList = [EventSerializer(event).data for event in eventList]
            return Response(eventDataList, status=status.HTTP_200_OK)

        else:
            return Response(
                {"Error": "Invalid request"}, status=status.HTTP_404_NOT_FOUND
            )


class createEvent(APIView):
    serializer_class = CreateEventSerializer

    def post(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()
        body_unicode = request.body.decode("utf-8")
        body = json.loads(body_unicode)
        email = body["email"]

        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            eventId = generateID()
            while len(events.objects.filter(eventID=eventId)) != 0:
                eventId = generateID()
            name = serializer.data.get("name")
            date = serializer.data.get("date")
            description = serializer.data.get("description")
            duration = int(serializer.data.get("duration"))
            region = serializer.data.get("region")
            city = serializer.data.get("city")
            type = serializer.data.get("type")
            minPrice = int(serializer.data.get("minPrice"))
            maxPrice = int(serializer.data.get("maxPrice"))

            event = events(
                eventID=eventId,
                name=name,
                date=date,
                description=description,
                duration=duration,
                region=region,
                city=city,
                type=type,
                minPrice=minPrice,
                maxPrice=maxPrice,
            )
            event.save()

            theKey = generateID()
            while len(manages.objects.filter(key=theKey)) != 0:
                theKey = generateID()
            manage = manages(email=email, eventID=eventId, key=theKey)
            manage.save()
            print("manages saved successfully")
            return Response(EventSerializer(event).data, status=status.HTTP_201_CREATED)

        return Response(
            {"Bad Request": "Invalid data..."}, status=status.HTTP_400_BAD_REQUEST
        )

    def get(self, request):
        return Response("Get Response")


class searchEvent(APIView):

    serializer_class = SearchEventSerializer

    url_email_word = "email"

    def post(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():

            theEvent = events.objects.filter(
                name__iregex=r"[a-z]*(" + serializer.data.get("name") + ")+[a-z]*"
            )

            theEvent2 = events.objects.filter(
                # type__iregex=r"[a-z]*(" +serializer.data.get("name") + ")+[a-z]*"
                type__iexact=serializer.data.get("name")
            )

            eventListTemp = []
            for event in theEvent:
                eventListTemp.append(event)
            for event in theEvent2:
                if event not in eventListTemp:
                    eventListTemp.append(event)

            if len(eventListTemp) == 0:
                return Response(
                    {"Error": "Event not found"},
                    headers=headers,
                    status=status.HTTP_204_NO_CONTENT,
                )

            email = request.GET.get(self.url_email_word)

            if email == None:
                return Response(
                    "No email given!",
                    status=status.HTTP_203_NON_AUTHORITATIVE_INFORMATION,
                )

            eventList = []
            for event in eventListTemp:
                eventData = EventSerializer(event).data
                eventData["isSaved"] = (
                    len(saves.objects.filter(email=email, eventID=event.eventID)) != 0
                )
                eventData["isBought"] = (
                    len(buys.objects.filter(email=email, eventID=event.eventID)) != 0
                )
                eventList.append(eventData)

            return Response(eventList, headers=headers, status=status.HTTP_302_FOUND)

        return Response(
            {"Bad Request": "Invalid data..."},
            headers=headers,
            status=status.HTTP_400_BAD_REQUEST,
        )


class deleteEvent(APIView):
    serializer_class = EventSerializer
    lookup_url_word = "id"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        event_id = request.GET.get(self.lookup_url_word)

        if event_id != None:
            try:
                event = events.objects.get(eventID=event_id)
            except:
                return Response(
                    {"Event Not Found": "Invalid Event ID."},
                    status=status.HTTP_404_NOT_FOUND,
                )

            manage = manages.objects.get(eventID=event_id)
            manage.delete()
            event.delete()
            return Response({"Success": "Event Deleted"}, status=status.HTTP_200_OK)

        return Response(
            {"Bad Request": "Id paramater not found in request"},
            status=status.HTTP_400_BAD_REQUEST,
        )


class editEvent(APIView):
    serializer_class = CreateEventSerializer
    lookup_url_word = "id"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        event_id = request.GET.get(self.lookup_url_word)

        if event_id != None:
            try:
                event = events.objects.get(eventID=event_id)
            except:
                return Response(
                    {"Event Not Found": "Invalid Event ID."},
                    status=status.HTTP_404_NOT_FOUND,
                )

            return Response(EventSerializer(event).data, status=status.HTTP_200_OK)

        return Response(
            {"Bad Request": "Id paramater not found in request"},
            status=status.HTTP_400_BAD_REQUEST,
        )

    def post(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        event_id = request.GET.get(self.lookup_url_word)

        if event_id != None:
            try:
                event = events.objects.get(eventID=event_id)
            except:
                return Response(
                    {"Event Not Found": "Invalid Event ID."},
                    status=status.HTTP_404_NOT_FOUND,
                )

        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            event.name = serializer.data.get("name")
            event.date = serializer.data.get("date")
            event.duration = serializer.data.get("duration")
            event.description = serializer.data.get("description")
            event.region = serializer.data.get("region")
            event.city = serializer.data.get("city")
            event.type = serializer.data.get("type")
            event.minPrice = serializer.data.get("minPrice")
            event.maxPrice = serializer.data.get("maxPrice")

            event.save()

            return Response(EventSerializer(event).data, status=status.HTTP_200_OK)

        return Response(
            {"Bad Request": "Invalid data..."}, status=status.HTTP_400_BAD_REQUEST
        )


class showSavedEvents(APIView):

    serializer_class = SaveEventSerializer

    url_email_word = "email"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        email = request.GET.get(self.url_email_word)

        if email != None:

            save_query = saves.objects.filter(email=email)
            print("first query")

            event_id_list = []
            for save in save_query:
                if save.eventID not in event_id_list:
                    event_id_list.append(save.eventID)

            print("got event id")
            if len(event_id_list) == 0:
                return Response(
                    {"Event Not Found": "User has not liked any event."},
                    status=status.HTTP_404_NOT_FOUND,
                )

            event_list = []
            for id in event_id_list:
                event = events.objects.filter(eventID=id)
                if len(event) != 0:
                    event_list.append(event[0])
            print("eventlist")
            event_data_list = [EventSerializer(event).data for event in event_list]
            print("event data list")

            return Response(event_data_list, status=status.HTTP_200_OK)

        return Response(
            {"Bad Request": "User Id paramater not found in request"},
            status=status.HTTP_400_BAD_REQUEST,
        )


class saveEvent(APIView):

    serializer_class = SaveEventSerializer

    url_email_word = "email"
    url_event_id_word = "eid"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        email = request.GET.get(self.url_email_word)
        event_id = request.GET.get(self.url_event_id_word)

        if event_id != None:
            key = generateID()
            while len(saves.objects.filter(key=key)) != 0:
                key = generateID()

            userSave = saves(email=email, eventID=event_id, key=key)
            userSave.save()
            print("event saved to " + email)
            return Response(
                SaveEventSerializer(userSave).data, status=status.HTTP_201_CREATED
            )

        return Response("No event id given!", status=status.HTTP_400_BAD_REQUEST)


class removeSavedEvent(APIView):

    serializer_class = SaveEventSerializer

    url_email_word = "email"
    url_event_id_word = "eid"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        email = request.GET.get(self.url_email_word)
        event_id = request.GET.get(self.url_event_id_word)

        if event_id != None and email != None:
            userSave = saves.objects.filter(eventID=event_id).filter(email=email)
            if len(userSave) == 0:
                return Response(
                    "This event is not saved", status=status.HTTP_204_NO_CONTENT
                )

            userSave[0].delete()
            return Response("deleted", status=status.HTTP_200_OK)

        return Response("No event id given!", status=status.HTTP_400_BAD_REQUEST)


class filterEvent(APIView):

    url_lookup_price = "priceRange"
    url_lookup_date = "dateRange"
    url_lookup_location = "location"
    url_lookup_type = "type"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        priceRange = request.GET.get(self.url_lookup_price)
        dateRange = request.GET.get(self.url_lookup_date)
        eventType = request.GET.get(self.url_lookup_type)
        location = request.GET.get(self.url_lookup_location)

        eventList = events.objects.all()

        if priceRange != None:
            priceList = str(priceRange).split("_")
            priceListInt = [int(obj) for obj in priceList]
            eventList = eventList.filter(minPrice__lte=priceListInt[1]).filter(
                maxPrice__gte=priceListInt[0]
            )

        if dateRange != None:
            dateList = str(dateRange).split("_")
            eventList = eventList.filter(date__gte=dateList[0]).filter(
                date__lte=dateList[1]
            )

        if eventType != None:
            eventList = eventList.filter(type=eventType)

        if location != None:
            eventList = eventList.filter(city=location)

        if len(eventList) == 0:
            return Response(
                {"Error": "No event found"}, status=status.HTTP_404_NOT_FOUND
            )

        eventDataList = [EventSerializer(event).data for event in eventList]
        return Response(eventDataList, status=status.HTTP_200_OK)


class organiserEvents(APIView):
    serializer_class = EventSerializer

    lookup_url_word_email = "email"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        email = request.GET.get(self.lookup_url_word_email)

        if email == None:
            return Response("No email given", status=status.HTTP_404_NOT_FOUND)

        managesList = manages.objects.filter(email=email)
        eventIDList = [event.eventID for event in managesList]
        eventList = [events.objects.get(eventID=id) for id in eventIDList]
        eventDataList = [EventSerializer(event).data for event in eventList]

        return Response(eventDataList, status=status.HTTP_200_OK)


class buyTicket(APIView):

    serializer_class = BuyTicketSerializer

    def post(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            key = generateID()
            while len(buys.objects.filter(key=key)) != 0:
                key = generateID()
            email = serializer.data.get("email")
            eventID = serializer.data.get("eventID")

            userBuy = buys(email=email, eventID=eventID, key=key)
            userBuy.save()
            return Response(
                BuyTicketSerializer(userBuy).data, status=status.HTTP_201_CREATED
            )

        return Response("Information is not valid!", status=status.HTTP_400_BAD_REQUEST)


class showTickets(APIView):

    url_email_word = "email"

    def get(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        email = request.GET.get(self.url_email_word)

        if email != None:

            buy_query = buys.objects.filter(email=email)

            event_id_list = [ticket.eventID for ticket in buy_query]

            if len(event_id_list) == 0:
                return Response(
                    {"Event Not Found": "User has not bought any ticket."},
                    status=status.HTTP_404_NOT_FOUND,
                )

            event_list = []
            for id in event_id_list:
                event = events.objects.filter(eventID=id)
                if len(event) != 0:
                    event_list.append(event[0])

            event_data_list = [EventSerializer(event).data for event in event_list]

            return Response(event_data_list, status=status.HTTP_200_OK)

        return Response(
            {"Bad Request": "User Id paramater not found in request"},
            status=status.HTTP_400_BAD_REQUEST,
        )


class showByType(APIView):
    def post(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        body_unicode = request.body.decode("utf-8")
        body = json.loads(body_unicode)
        type = body["type"]
        email = body["email"]

        if email == "":
            return Response(
                "No email given!", status=status.HTTP_203_NON_AUTHORITATIVE_INFORMATION
            )

        if type == "":
            return Response(
                "No type information given!", status=status.HTTP_204_NO_CONTENT
            )

        eventList = events.objects.filter(type=type)

        if len(eventList) == 0:
            return Response(
                "No event with this type found", status=status.HTTP_404_NOT_FOUND
            )

        eventDataList = []
        for event in eventList:
            eventData = EventSerializer(event).data
            eventData["isSaved"] = (
                len(saves.objects.filter(email=email, eventID=event.eventID)) != 0
            )
            eventData["isBought"] = (
                len(buys.objects.filter(email=email, eventID=event.eventID)) != 0
            )
            eventDataList.append(eventData)

        return Response(eventDataList, status=status.HTTP_200_OK)
