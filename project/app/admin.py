from django.contrib import admin
from .models import *
from django.contrib.auth.admin import UserAdmin
class customUserAdmin(UserAdmin):
    fieldsets = (
        (None, {'fields': ('email', 'password', 'username', 'last_login','profilePicture','profilePicId')}),
        ('Permissions', {'fields': (
            'is_active', 
            'is_staff', 
            'is_superuser',
            'groups', 
            'user_permissions',
        )}),
    )
    add_fieldsets = (
        (
            None,
            {
                'classes': ('wide',),
                'fields': ('email', 'password1', 'password2','username','profilePicture','profilePicId')
            }
        ),
    )

    list_display = ('email', 'username', 'is_staff', 'last_login')
    list_filter = ('is_staff', 'is_superuser', 'is_active', 'groups')
    search_fields = ('email',)
    ordering = ('email',)
    filter_horizontal = ('groups', 'user_permissions',)
# Register your models here.
admin.site.register(customUser,customUserAdmin)
admin.site.register(Post)
admin.site.register(Like)
admin.site.register(Comment)
admin.site.register(Club)
admin.site.register(Event)
admin.site.register(LostAndFound)
admin.site.register(Issue)
admin.site.register(Support)