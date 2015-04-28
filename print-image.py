#!/usr/bin/python

from Adafruit_Thermal import *
import Image
import sys

def main():
  printer = Adafruit_Thermal("/dev/ttyAMA0", 19200, timeout=5)
  try:
    image = Image.open(sys.argv[1])
  except Exception as e:
    print(e)
    print("Usage: " + sys.argv[0] + " <filename>")
    sys.exit(1)

  printer.printImage(image, True)
  printer.println()
  printer.println()

main()
