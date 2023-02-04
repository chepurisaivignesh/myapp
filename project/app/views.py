from .models import *
from .serializers import *
from django.conf import settings as djangoSetting
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from django.core.files.storage import default_storage
from random import random
from datetime import datetime
from rest_framework.authtoken.models import Token

# Create your views here .
class PostView(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def get(self,request):
        query=Post.objects.all().order_by('-id')#Latest First
        serializers=PostSerializer(query,many=True)
        data=[]
        for post in serializers.data:
            
            myLike=Like.objects.filter(post=post['id']).filter(user=request.user).first()
            if myLike:
                post['myLike']=myLike.like
            else:
                post['myLike']=False

            post_like_count=Like.objects.filter(post=post['id']).filter(like=True).count()
            post['likeCount']=post_like_count

            post_comment_count=Comment.objects.filter(post=post['id']).count()
            post['commentCount']=post_comment_count

            comment_query=Comment.objects.filter(post=post['id']).order_by('-id')#Latest First
            comment_serializer=CommentSerializer(comment_query,many=True)
            post['comments']=comment_serializer.data
            data.append(post)
        return Response(data)

class SpecificPostView(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def get(self,request):
        
        query=Post.objects.filter(user=request.user).order_by('-id')#Latest First
        serializers=PostSerializer(query,many=True)
        data=[]
        for post in serializers.data:
            
            myLike=Like.objects.filter(post=post['id']).filter(user=request.user).first()
            if myLike:
                post['myLike']=myLike.like
            else:
                post['myLike']=False

            post_like_count=Like.objects.filter(post=post['id']).filter(like=True).count()
            post['likeCount']=post_like_count

            post_comment_count=Comment.objects.filter(post=post['id']).count()
            post['commentCount']=post_comment_count

            comment_query=Comment.objects.filter(post=post['id']).order_by('-id')#Latest First
            comment_serializer=CommentSerializer(comment_query,many=True)
            post['comments']=comment_serializer.data
            data.append(post)
        return Response(data)

class AddLike(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]

    def post(self,request):
        try:
            data=request.data
            current_user=request.user
            post_id=data['id']
            post_obj=Post.objects.get(id=post_id)

            like_obj=Like.objects.filter(post=post_obj).filter(user=current_user).first()

            if like_obj:
                oldLikeObj=like_obj.like
                like_obj.like=not oldLikeObj
                like_obj.save()
            else:
                Like.objects.create(post=post_obj,user=current_user,like=True)
            responseMsg={'error':False}
        except:
            responseMsg={'error':True}
        
        return Response(responseMsg)

class AddComment(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            current_user=request.user
            data=request.data
            post_id=data['postId']
            post_obj=Post.objects.get(id=post_id)
            comment_text=data['commentText']

            Comment.objects.create(user=current_user,post=post_obj,commentDescription=comment_text)
            response_msg={'error':False,'postid':post_id}
        except:
            response_msg={'error':True}
        return Response(response_msg)

class AddPost(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            current_user=request.user
            data=request.data
            postDesc=data['postDesc']
            postImageUrl=data['imageUrl']
            Post.objects.create(user=current_user,description=postDesc,postPicture=postImageUrl)
            response_msg={'error':False}
        except:
            response_msg={'error':True}
        return Response(response_msg)

class AddImage(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            data=request.data
            user=request.user
            print(data)
            image = request.FILES["image"]
            directory = data['directory']
            
            # Save the file to a specific directory on your local filesystem
            # you can use the `default_storage.save()` method to save the file
            # path = default_storage.save(djangoSetting.MEDIA_ROOT+'postPics/', image)
            path=default_storage.save(directory+user.username+'-'+str(random())[2:]+'.jpg',image)
            # path=fs.save(str(random.random()*693)+'-'+datetime.now().strftime()+'.jpg',image)
            # datetime.now().strftime("%m/%d/%Y, %H:%M:%S")
            # path=fs.save(user.username+'-'+str(random())[2:]+'.jpg',image)
            print("Saved on django admin",path)
            return Response({'status': 'success','imageUrl':path})
        except:
            return Response({'status': 'error'})

class getCurrentUser(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]

    def get(self,request):
        try:
            
            user_id = Token.objects.get(key=request.auth.key).user_id
            user = customUser.objects.get(id=user_id)
            serializers=UserSerializer(user)
            return Response({'error':False,'userDetails':serializers.data})
        except:
            return Response({'error':True})

class getClub(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]

    def get(self,request):
        try:
            club=Club.objects.all()
            serializers=ClubSerializer(club,many=True)
            return Response({'error':False,'clubdetails':serializers.data})
        except:
            return Response({'error':True})

class AddEvent(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            current_user=request.user
            data=request.data
            host=data['host']
            eventName=data['eventName']
            eventDescription=data['eventDescription']
            eventDate=data['eventDate']
            print(eventDate)
            eventImageUrl=data['imageUrl']
            Event.objects.create(host=host,eventName=eventName,eventDescription=eventDescription,eventDate=eventDate,eventPicture=eventImageUrl)
            response_msg={'error':False}
        except:
            response_msg={'error':True}
        return Response(response_msg)

class getEvents(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]

    def get(self,request):
        try:
            events=Event.objects.all().order_by('eventDate')
            serializer=EventSerializer(events,many=True)
            return Response({'error':False,'events':serializer.data})
        except:
            return Response({'error':True})

class AddLFItem(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            current_user=request.user
            data=request.data
            contact=data['contact']
            description=data['description']
            lostDate=data['lostDate']
            lostImageUrl=data['imageUrl']
            location=data['location']
            LostAndFound.objects.create(user=current_user,contact=contact,description=description,lostDate=lostDate,pic=lostImageUrl,location=location)
            response_msg={'error':False}
        except:
            response_msg={'error':True}
        return Response(response_msg)

class getLFitems(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]

    def get(self,request):
        try:
            items=LostAndFound.objects.all().order_by('-id')#Latest First
            serializer=LostAndFoundSerializer(items,many=True)
            return Response({'error':False,'items':serializer.data})
        except:
            return Response({'error':True})

class deletePost(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            data=request.data 
            idToBeDeleted=data['id']
            Post.objects.filter(id=idToBeDeleted).delete()
            return Response({'error':False,})
        except:
            return Response({'error':True,})

class updateUser(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            user_id = Token.objects.get(key=request.auth.key).user_id
            customUser.objects.filter(id=user_id).update(profilePicId=request.data['profilePicId'],username=request.data['username'])
            return Response({'error':False,})
        except:
            return Response({'error':True,})

class deleteLFitem(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            LFitemIDToBeDeleted = request.data['id']
            LostAndFound.objects.filter(id=LFitemIDToBeDeleted).delete()
            return Response({'error':False,})
        except:
            return Response({'error':True,})

class getIssues(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def get(self,request):
        try:
            items=Issue.objects.all().order_by('-id')#Latest First
            serializer=IssueSerializer(items,many=True)
            return Response({'error':False,'items':serializer.data})
        except:
            return Response({'error':True})

class IssueView(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def get(self,request):
        query=Issue.objects.all().order_by('-id')#Latest First
        serializers=IssueSerializer(query,many=True)
        data=[]
        for issue in serializers.data:
            
            mySupport=Support.objects.filter(issue=issue['id']).filter(user=request.user).first()
            if mySupport:
                issue['mySupport']=mySupport.supportReaction
            else:
                issue['mySupport']=False

            issue_support_count=Support.objects.filter(issue=issue['id']).filter(supportReaction=True).count()
            issue['supportCount']=issue_support_count

            data.append(issue)
        return Response(data)

class showSupportReaction(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]

    def post(self,request):
        try:
            data=request.data
            current_user=request.user
            issue_id=data['id']
            issue_obj=Issue.objects.get(id=issue_id)

            support_obj=Support.objects.filter(issue=issue_obj).filter(user=current_user).first()

            if support_obj:
                oldSupportObj=support_obj.supportReaction
                support_obj.supportReaction=not oldSupportObj
                support_obj.save()
            else:
                Support.objects.create(issue=issue_obj,user=current_user,supportReaction=True)
            responseMsg={'error':False}
        except:
            responseMsg={'error':True}
        
        return Response(responseMsg)

        
class AddIssue(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            current_user=request.user
            data=request.data
            issueDescription=data['issueDescription']
            issueImageUrl=data['imageUrl']
            Issue.objects.create(user=current_user,description=issueDescription,pic=issueImageUrl)
            response_msg={'error':False}
        except:
            response_msg={'error':True}
        return Response(response_msg)

class deleteIssueitem(APIView):
    permission_classes=[IsAuthenticated,]
    authentication_classes=[TokenAuthentication]
    def post(self,request):
        try:
            issueitemIDToBeDeleted = request.data['id']
            Issue.objects.filter(id=issueitemIDToBeDeleted).delete()
            return Response({'error':False,})
        except:
            return Response({'error':True,})