#---------------------------------------------------------------
# Paul Chyz, Chloe Stevens, Rachel Cheung, and Michael Frentress
# Created v1.0: 9/21/2018
#---------------------------------------------------------------

import random, re, os
from flask import Flask, render_template
from multiprocessing import Value

# Configure parameters
fileName = "countVal.txt"
photoPath = r"/static/Images"
photoExtension = r".jpg"

app = Flask(__name__)

@app.route("/")
def main():

    # If text file doesn't exist, create it and write 0
    if not os.path.exists(fileName):
        F = open(fileName, "w")
        F.write("0")
        F.close()

    # Open file with read and write permissions, strip contents of non-numeric characters, and store as integer
    F = open(fileName, "r+")
    oldVal = int(re.sub('[^0-9]','', F.read()))

    # Increment count value and overwrite file with updated value as a string
    newVal = oldVal + 1
    F.truncate(0)
    F.write(str(newVal))
    F.close()

    # Create string with formatted count value and grammar check
    if newVal == 1:
        count = "{:,} dog has been booped.".format(newVal)
    else:
        count = "{:,} dogs have been booped.".format(newVal)

    # Generate random number corresponding to numeric photo filenames, and concatenate into path
    photoTotal = len(os.listdir(os.getcwd() + r'/static/Images')) - 1
    number = random.randint(1, photoTotal)
    photo = photoPath + r"/" + str(number) + photoExtension
    
    # Return values to html template
    return render_template('index.html', photo=photo, count=count)

# Run app at machine's IP and port 5000
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)