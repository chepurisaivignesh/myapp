# Generated by Django 4.1.5 on 2023-02-03 15:23

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0006_club_members_club_supervising_faculty_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('host', models.TextField()),
                ('eventName', models.TextField()),
                ('eventDescription', models.TextField()),
                ('eventDate', models.DateField()),
                ('eventPicture', models.ImageField(blank=True, null=True, upload_to='')),
            ],
        ),
        migrations.CreateModel(
            name='LostAndFound',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.TextField()),
                ('contact', models.TextField()),
                ('pic', models.ImageField(blank=True, null=True, upload_to='')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
