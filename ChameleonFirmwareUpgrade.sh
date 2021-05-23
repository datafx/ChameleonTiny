#!/bin/bash

if ! command -v dfu-programmer &> /dev/null
then
    echo "Cannot find dfu-programmer. Please install dfu-programmer and make sure it is in your PATH"
    exit
fi

if [ ! -f Chameleon-Mini.eep ]; then
    echo "Cannot find Chameleon-Mini.eep. Please run this script in the same directory where Chameleon-Mini.eep and Chameleon-RevG.hex are saved."
    exit
fi

if [ ! -f Chameleon-Mini.hex ]; then
    echo "Cannot find Chameleon-Mini.hex. Please run this script in the same directory where Chameleon-Mini.eep and Chameleon-RevG.hex are saved."
    exit
fi

dfu-programmer atxmega128a4u erase
wait

if [ $? -eq 0 ]
then
  echo "Flash Erased"
else
  echo "There was an error with executing this command. Maybe your ChameleonMini is not in bootloader mode?" >&2
  exit 1
fi

dfu-programmer atxmega128a4u flash-eeprom "Chameleon-Mini.eep" --force
wait

if [ $? -eq 0 ]
then
  echo "eep flashed successfully"
else
  echo "There was an error with executing this command. Maybe your ChameleonMini is not in bootloader mode?" >&2
  exit 1
fi

dfu-programmer atxmega128a4u flash "Chameleon-Mini.hex" 
wait

if [ $? -eq 0 ]
then
  echo "hex flashed successfully"
else
  echo "There was an error with executing this command. Maybe your ChameleonMini is not in bootloader mode?" >&2
  exit 1
fi

dfu-programmer atxmega128a4u launch
wait

echo "Flashing the firmware to your ChameleonMini is finished now."
