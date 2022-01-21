from rest_framework import serializers, status, generics
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import UserSerializer, CreateUserSerializer, LoginUserSerializer
from rest_framework.views import APIView
from .models import generateID, userdata


headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": True,
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
}


@api_view(["GET"])
def apiOverview(request):
    api_urls = {"login": "/login/", "register": "/register/"}

    return Response(api_urls)


class userList(generics.ListAPIView):
    queryset = userdata.objects.all()
    serializer_class = UserSerializer


class registerUser(APIView):
    serializer_class = CreateUserSerializer

    def post(self, request, format=None):
        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            email = serializer.data.get("email")
            password = serializer.data.get("password")
            type = serializer.data.get("type")
            location = serializer.data.get("location")

            user_id = generateID()
            while len(userdata.objects.filter(userID=user_id)) != 0:
                user_id = generateID()
            user = userdata(
                email=email,
                password=password,
                type=type,
                userID=user_id,
                location=location,
            )
            user.save()
            request.session["email"] = email
            print(request.session["email"])
            return Response(
                UserSerializer(user).data,
                headers=headers,
                status=status.HTTP_201_CREATED,
            )

        return Response(
            {"Bad Request": "Invalid data..."},
            headers=headers,
            status=status.HTTP_400_BAD_REQUEST,
        )

    def get(self, request):
        return Response("Get response")


class loginUser(APIView):
    serializer_class = LoginUserSerializer

    def post(self, request, format=None):

        if not self.request.session.exists(self.request.session.session_key):
            self.request.session.create()

        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            try:
                theUser = userdata.objects.get(email=serializer.data.get("email"))
            except:
                return Response(
                    {"Error": "User not found"},
                    headers=headers,
                    status=status.HTTP_404_NOT_FOUND,
                )

            if theUser.password == serializer.data.get("password"):
                request.session["email"] = serializer.data.get("email")
                print(request.session["email"])
                return Response(
                    {"type": theUser.type, "location": theUser.location},
                    headers=headers,
                    status=status.HTTP_302_FOUND,
                )
            else:
                return Response(
                    {"Error": "Password is incorrect"},
                    status=status.HTTP_401_UNAUTHORIZED,
                    headers=headers,
                )

        return Response(
            {"Bad Request": "Invalid data..."},
            headers=headers,
            status=status.HTTP_400_BAD_REQUEST,
        )

    def get(self, request):
        return Response("Get response")
