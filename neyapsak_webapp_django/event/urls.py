from django.urls import path
from . import views

urlpatterns = [
    path("", views.eventList.as_view(), name="event-home"),
    path("list/", views.eventList.as_view(), name="event-list"),
    path("create/", views.createEvent.as_view(), name="create-event"),
    path("search/", views.searchEvent.as_view(), name="search-event"),
    path("delete/", views.deleteEvent.as_view(), name="delete-event"),
    path("edit/", views.editEvent.as_view(), name="edit-event"),
    path("save/", views.saveEvent.as_view(), name="save-event"),
    path("showSaved/", views.showSavedEvents.as_view(), name="show-saved-event"),
    path("filter/", views.filterEvent.as_view(), name="filter-event"),
    path("organiserEvents/", views.organiserEvents.as_view(), name="organiser-events"),
    path("removeSaved/", views.removeSavedEvent.as_view(), name="remove-saved-event"),
    path("buyTicket/", views.buyTicket.as_view(), name="buy-event-ticket"),
    path("showTicket/", views.showTickets.as_view(), name="show-ticket"),
    path("showByType/", views.showByType.as_view(), name="show-by-type"),
]
