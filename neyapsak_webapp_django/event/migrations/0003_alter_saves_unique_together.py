# Generated by Django 3.2.8 on 2021-12-14 12:49

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('event', '0002_saves'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='saves',
            unique_together=set(),
        ),
    ]