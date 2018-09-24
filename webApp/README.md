# Booper Web App

This web app is a dog "booper" app. The app displays a randomized dog image from a given directory, repeating every time the user clicks on (boops) the dog image. It also records the total number of clicks (boops) in a text file and displays it on the web app.

## Getting Started

These instructions will walk you through the steps to run this app on your local machine. For details on deploying the web app on a public IP address via Oracle Cloud Infrastructure, see the [OCIdeployment](https://github.com/paulchyz/Booper) directory in this Booper repository.

### Prerequisites

* Python 2.7
* Flask
* Dog images to populate the web app

Installing Flask:
```
pip install Flask
```

### File Structure

Create a directory on your local machine to use as the working directory for the web app.  This directory should contain the "doggo.py" python script and two subdirectories, one named "static" and one named "templates." The "static" subdirectory should contain another subdirectory named "Images," where you will add images to display on the web app. The "templates" subdirectory should contain an html file called "index.html."

### Adding Photos

Any photos you want to display need to be added to the "Images" directory. Every photo in the directory must have the same extension (case-sensitive). Additionally, the photos need to be named numerically starting with 1. For example, 100 jpg photos would start with "1.jpg" and end with "100.jpg." It is also worth noting that any changes to your photo directory may not appear in your browser until you clear your browser's cached images.

### Configuration

Open "doggo.py" in your editor of choice. There are three configuration parameters in the beginning of the python code that allow for customization of the operation of the web app.

The fileName variable defines the name of a text file that python will create and edit. This file stores the current number of visits to the website, which allows the web app to display the number of "boops." This file is set to "countVal.txt" as default.

```
fileName = "countVal.txt"
```

The photoPath variable defines the path to the Images folder relative to the working directory for "doggo.py." If the file structure is set up as defined above, this should not change. If you have changed the file structure, you will have to update this path to reflect your changes.

```
photoPath = r"/static/Images"
```

The photoExtension variable sets the type of photos that are used for the web app. The default extension is .jpg, but this can be changed if desired. Keep in mind that every photo in the "Images" directory should have the same extension, and that the extensions are case-sensitive.

```
photoExtension = r".jpg"
```

## Running on Localhost

The web app will run on the host and port defined at the end of the "doggo.py" file. The host address is set as default to '0.0.0.0' which will allow it to run as localhost. The port is set as default to port 5000. This can be changed if you prefer a different port, but note that ports 0-1023 should be avoided as they are system ports.

```
app.run(host='0.0.0.0', port=5000)
```

Run the web app:
```
python doggo.py
```

## Running on Public IP

To run the web app on a public IP, there is documentation in the [OCIdeployment](https://github.com/paulchyz/Booper) directory of this repository. That documentation provides a walkthrough for hosting the web app on a compute instance on Oracle Cloud Infrastructure, where it can be accessed on a highly available public IP address.

## Authors

* **Paul Chyz**
* **Michael Frentress**
* **Chloe Stevens**
* **Rachel Cheung**