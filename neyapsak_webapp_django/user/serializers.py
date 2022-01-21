from rest_framework import serializers
from .models import userdata

class UserSerializer(serializers.ModelSerializer):
	class Meta:
		model = userdata
		fields = ('email', 'password', 'type', 'userID')

class CreateUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = userdata
        fields = ('email', 'password', 'type', 'location')

class LoginUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = userdata
        fields = ('email', 'password')