# Generated by Django 4.1.5 on 2023-01-27 09:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0003_alter_customuser_username'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='postPicture',
            field=models.ImageField(default='C:\\Users\\janas\\Downloads\\withytcode\\project\\media/postPics/default.jpg', upload_to=''),
        ),
    ]
