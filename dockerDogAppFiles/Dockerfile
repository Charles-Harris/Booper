# Use a Python runtime as a parent image
From python:2.7-slim
# Set the working directory to the app
WORKDIR /DoggoWithAJobbo
# Copy cd contents into container
ADD . /DoggoWithAJobbo
# Install any needed packages specified in req.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt
# Port 80 open the pod-bay door, HAL
Expose 5100
# Define env. var.
ENV NAME World
#Run the app when the container launches
CMD ["python", "doggo.py"]
