from django.conf import settings
from rest_framework import serializers
from .models import *

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model=customUser
        fields=('id','username','email','profilePicture','profilePicId','is_staff','is_superuser')
        # fields='__all__'
    
class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model=Post
        fields="__all__"
        # depth=1
    def to_representation(self, instance):
        response=super().to_representation(instance)
        response['user']=UserSerializer(instance.user).data
        return response
        
class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model=Comment
        fields="__all__"
        # depth=1
    def to_representation(self, instance):
        response=super().to_representation(instance)
        response['user']=UserSerializer(instance.user).data
        return response

class ClubSerializer(serializers.ModelSerializer):
    heads = UserSerializer(many=True, read_only=True)
    members = UserSerializer(many=True, read_only=True)
    supervising_faculty = UserSerializer(many=True, read_only=True)
    class Meta:
        model=Club
        
        fields='__all__'
        # depth=1

class LostAndFoundSerializer(serializers.ModelSerializer):
    class Meta:
        model=LostAndFound
        fields="__all__"
        # depth=1
    def to_representation(self, instance):
        response=super().to_representation(instance)
        response['user']=UserSerializer(instance.user).data
        return response

class EventSerializer(serializers.ModelSerializer):
    class Meta:
        model=Event
        fields="__all__"

class IssueSerializer(serializers.ModelSerializer):
    class Meta:
        model=Issue
        fields="__all__"
        
    def to_representation(self, instance):
        response=super().to_representation(instance)
        response['user']=UserSerializer(instance.user).data
        return response