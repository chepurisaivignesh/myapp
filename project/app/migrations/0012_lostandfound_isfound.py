# Generated by Django 4.1.5 on 2023-02-04 13:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0011_customuser_profilepicid'),
    ]

    operations = [
        migrations.AddField(
            model_name='lostandfound',
            name='isFound',
            field=models.BooleanField(default=False),
        ),
    ]
