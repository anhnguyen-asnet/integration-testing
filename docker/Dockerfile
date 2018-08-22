FROM anhnguyenkim/docker-img-django:develop

COPY . /usr/local/src/django_ci

WORKDIR /usr/local/src/django_ci

# Collect admin's static assets silently
RUN cd django_ci && python manage.py collectstatic --noinput > /dev/null 2>&1

# The port that the gunicorn web application is running
EXPOSE 80

ENTRYPOINT ["bin/entrypoint.sh"]

CMD ["bin/dj-gunicorn.sh", "80"]
