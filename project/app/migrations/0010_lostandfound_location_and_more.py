# Generated by Django 4.1.5 on 2023-02-04 08:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0009_alter_event_eventpicture_alter_lostandfound_pic_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='lostandfound',
            name='location',
            field=models.TextField(default='NIT Calicut'),
        ),
        migrations.AlterField(
            model_name='customuser',
            name='profilePicture',
            field=models.ImageField(default='default.jpg', upload_to=''),
        ),
    ]
