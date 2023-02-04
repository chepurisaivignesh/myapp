from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
import PIL
from datetime import datetime

class customUser(AbstractUser):
    username = models.CharField(max_length = 50, blank = True, null = True, unique = True)
    email=models.EmailField(blank=False,null=False,unique=True)
    profilePicture=models.ImageField(default=settings.MEDIA_ROOT + 'default.jpg')
    postLength=models.PositiveIntegerField(default=0,)
    first_name = None
    last_name = None
    profilePicId=models.IntegerField(default=1)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    def __str__(self):
        return self.email


# Create your models here.
class Post(models.Model):
    user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    description=models.TextField()
    createdDate=models.DateField(auto_now_add=True)
    likeCount=models.PositiveIntegerField(default=0,)
    commentCount=models.PositiveIntegerField(default=0,)
    postPicture=models.ImageField(blank=True,null=True,upload_to='postPics/')

class Comment(models.Model):
    user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    post=models.ForeignKey(Post,on_delete=models.CASCADE)
    commentDescription=models.TextField(blank=False)
    createdDate=models.DateField(auto_now_add=True)
    
class Like(models.Model):
    user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    post=models.ForeignKey(Post,on_delete=models.CASCADE)
    like=models.BooleanField(default=False)
    
class Club(models.Model):
    name=models.TextField(blank=False,null=False)
    heads=models.ManyToManyField(customUser,related_name='head_users')
    members=models.ManyToManyField(customUser,related_name='member_users')
    description=models.TextField(blank=False)
    websiteLink=models.TextField(null=True,blank=True)
    images_directory=models.TextField(blank=False)
    supervising_faculty=models.ManyToManyField(customUser,related_name='faculty_users')

class Event(models.Model):
    host=models.TextField(null=False,blank=False)
    eventName=models.TextField(null=False,blank=False)
    eventDescription=models.TextField(null=False,blank=False)
    eventDate=models.DateField(null=False,blank=False)
    eventPicture=models.ImageField(blank=True,null=True,upload_to='eventPics/')

class LostAndFound(models.Model):
    user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    description=models.TextField(blank=False,null=False)
    contact=models.TextField(blank=False,null=False)
    pic=models.ImageField(blank=True,null=True,upload_to='LostAndFoundPics/')
    lostDate=models.DateField(null=False,blank=False,default=datetime.now)
    location=models.TextField(blank=False,null=False,default='NIT Calicut')
    isFound=models.BooleanField(default=False,blank=False,null=False)

class Issue(models.Model):
    user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    description=models.TextField(blank=False,null=False)
    pic=models.ImageField(blank=True,null=True,upload_to='LostAndFoundPics/')
    isSolved=models.BooleanField(default=False,blank=False,null=False)
    createdDate=models.DateField(auto_now_add=True)
    supportCount=models.PositiveIntegerField(default=0,)

class Support(models.Model):
    user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    issue=models.ForeignKey(Issue,on_delete=models.CASCADE)
    supportReaction=models.BooleanField(default=False)