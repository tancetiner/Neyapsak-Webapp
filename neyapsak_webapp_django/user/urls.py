from django.urls import path
from . import views

urlpatterns = [
    path("", views.userList.as_view(), name="api-overview"),
    path("list/", views.userList.as_view(), name="user-list"),
    path("register/", views.registerUser.as_view(), name="register-user"),
    path("login/", views.loginUser.as_view(), name="login-user"),
]
