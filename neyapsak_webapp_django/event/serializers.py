from rest_framework import serializers
from .models import events, saves, buys


class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model = events
        fields = (
            "eventID",
            "name",
            "date",
            "description",
            "duration",
            "region",
            "city",
            "type",
            "minPrice",
            "maxPrice",
        )


class CreateEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = events
        fields = (
            "name",
            "date",
            "description",
            "duration",
            "region",
            "city",
            "type",
            "minPrice",
            "maxPrice",
        )


class SearchEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = events
        fields = ("name",)


class SaveEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = saves
        fields = ("eventID", "email")


class BuyTicketSerializer(serializers.ModelSerializer):
    class Meta:
        model = buys
        fields = ("eventID", "email")
