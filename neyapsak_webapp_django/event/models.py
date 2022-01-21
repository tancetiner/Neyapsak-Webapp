from enum import unique
from django.db import models
import random

# Create your models here.
def generateID():
    return random.randint(1, 99999)


class events(models.Model):
    eventID = models.IntegerField(primary_key=True)
    date = models.DateField()
    name = models.CharField(max_length=50)
    duration = models.IntegerField()
    description = models.TextField(null=True, default="")
    region = models.CharField(max_length=50, null=True, default="")
    city = models.CharField(max_length=20)
    type = models.CharField(max_length=20)
    minPrice = models.IntegerField()
    maxPrice = models.IntegerField()


class saves(models.Model):
    key = models.IntegerField(primary_key=True, default=generateID)
    email = models.CharField(max_length=50)
    eventID = models.IntegerField()


class manages(models.Model):
    key = models.IntegerField(primary_key=True, default=generateID)
    email = models.CharField(max_length=50)
    eventID = models.IntegerField(primary_key=False)

    class Meta:
        unique_together = ("email", "eventID")


class buys(models.Model):
    key = models.IntegerField(primary_key=True, default=generateID)
    email = models.CharField(max_length=50)
    eventID = models.IntegerField(primary_key=False)

    class Meta:
        unique_together = ("email", "eventID")
