# use an officeal python runtime as a parent image
FROM python:3.5-slim

#set the working dir to /app
WORKDIR /app

# copy the current dir contens into the container at /app
COPY . /app

# install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

#Make port 80 available to the world outside this container
EXPOSE 80

# Define env vars
ENV Name world

# Run app.py when the container launches
CMD [ "python", "app.py" ]
