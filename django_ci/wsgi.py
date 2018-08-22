"""
WSGI config for django_ci project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/1.10/howto/deployment/wsgi/
"""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "django_ci.settings")

application = get_wsgi_application()


try:
    from raven.contrib.django.raven_compat.middleware.wsgi import Sentry
    application = Sentry(application)
except Exception as e:
    pass
