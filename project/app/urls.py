from django.urls import path
from .views import *
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('posts/',PostView.as_view(),),
    path('specificPosts/',SpecificPostView.as_view(),),
    path('getCurrentUser/',getCurrentUser.as_view(),),
    path('addLike/',AddLike.as_view(),),
    path('addComment/',AddComment.as_view(),),
    path('login/',obtain_auth_token),
    path('addImage/',AddImage.as_view()),
    path('addPost/',AddPost.as_view()),
    path('getClubs/',getClub.as_view()),
    path('addEvent/',AddEvent.as_view()),
    path('getEvents/',getEvents.as_view()),
    path('addLFitem/',AddLFItem.as_view()),
    path('getLFitems/',getLFitems.as_view()),
    path('deletePost/',deletePost.as_view()),
    path('updateUser/',updateUser.as_view(),),
    path('deleteLFitem/',deleteLFitem.as_view(),),
    path('getIssues/',IssueView.as_view(),),
    path('showSupport/',showSupportReaction.as_view(),),
    path('addIssue/',AddIssue.as_view(),),
    path('deleteIssueItem/',deleteIssueitem.as_view(),),

]
