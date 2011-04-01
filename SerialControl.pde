/*
  SerialControl.pde - Library for controlling my Quadcopter via the serial connection
  Created by Myles Grant <myles@mylesgrant.com>
  See also: https://github.com/grantmd/QuadCopter
  
  This program is free software: you can redistribute it and/or modify 
  it under the terms of the GNU General Public License as published by 
  the Free Software Foundation, either version 3 of the License, or 
  (at your option) any later version. 

  This program is distributed in the hope that it will be useful, 
  but WITHOUT ANY WARRANTY; without even the implied warranty of 
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
  GNU General Public License for more details. 

  You should have received a copy of the GNU General Public License 
  along with this program. If not, see <http://www.gnu.org/licenses/>. 
*/

//
// NB: We follow the AeroQuad serial control protocol: http://aeroquad.com/wiki/index.php/AeroQuad_Serial_Commands
// Interop FTW.
//

byte _queryType;

void readSerialCommand(){
  // Check for serial message
  if (Serial.available()){
    _queryType = Serial.read(); // Read the command first

    switch (_queryType){
      case 'A': // Receive roll and pitch gyro PID
        break;
      case 'C': // Receive yaw PID
        break;
      case 'E': // Receive roll and pitch auto level PID
        break;
      case 'G': // Receive auto level configuration
        break;
      case 'I': // Receive altitude hold PID
        break;
      case 'K': // Receive data filtering values
        break;
      case 'M': // Receive transmitter smoothing values
        break;
      case 'O': // Receive transmitter calibration values
        break;
      case 'W': // Write all user configurable values to EEPROM
        eeprom_write_all();
        break;
      case 'Y': // Initialize EEPROM with default values
        eeprom_read_all();
        break;
      case '1': // Calibrate ESCS's by setting Throttle high on all channels
        engines.disarm();
        engines.arm(1);
        break;
      case '2': // Calibrate ESC's by setting Throttle low on all channels
        engines.disarm();
        engines.arm(2);
        break;
      case '3': // Test ESC calibration
        engines.disarm();
        engines.setThrottle(constrain(readFloatSerial(), 1000, 1200));
        break;
      case '4': // Turn off ESC calibration
        engines.disarm();
        break;
      case '5': // Send individual motor commands (motor, command)
        engines.disarm();
        engines.setThrottle(constrain(readFloatSerial(), 1000, 1200));
        // HOW DOES THIS DIFFER FROM 3!?
        break;
      case 'a': // fast telemetry transfer
        // IGNORED
        break;
      case 'b': // calibrate gyros
        gyro.autoZero();
        // TODO: Store to EEPROM
        break;
      case 'c': // calibrate accels
        accel.autoZero();
        // TODO: Store to EEPROM
        break;
      case 'd': // send aref
        // IGNORED
        break;
      case 'f': // calibrate magnetometer
        // IGNORED
        break;
      case '~': // read Camera values 
        // IGNORED
        break;
    }
  }
}

void sendSerialTelemetry(){
  switch (_queryType){
    case '=': // Reserved debug command to view any variable from Serial Monitor
      //_queryType = 'X';
      break;
    case 'B': // Send roll and pitch gyro PID values
      serialPrintPID(ROLL);
      serialPrintPID(PITCH);
      Serial.println(1300); // TODO: Read from EEPROM
      _queryType = 'X';
      break;
    case 'D': // Send yaw PID values
      serialPrintPID(YAW);
      serialPrintPID(5); // TODO: Heading hold
      Serial.println(0, BIN);
      _queryType = 'X';
      break;
    case 'F': // Send roll and pitch auto level PID values
      serialPrintPID(3); // TODO: LEVELROLL
      serialPrintPID(4); // TODO: LEVELPITCH
      serialPrintPID(6); // TODO: LEVELGYROROLL
      serialPrintPID(7); // TODO: LEVELGYROPITCH
      Serial.println(1000.0); // TODO: windup guard
      _queryType = 'X';
      break;
    case 'H': // Send auto level configuration values
      serialPrintValueComma(500.0); // TODO: Read this from EEPROM
      Serial.println(150.0); // TODO: Read this from EEPROM
    
      _queryType = 'X';
      break;
    case 'J': // Altitude Hold
      for(byte i=0; i<9; i++) {
        serialPrintValueComma(0);
      }
      Serial.println('0');
    
      _queryType = 'X';
      break;
    case 'L': // Send data filtering values
      serialPrintValueComma(gyro.getSmoothFactor());
      serialPrintValueComma(accel.getSmoothFactor());
      Serial.println(7.0); // TODO: Read this from EEPROM
      _queryType = 'X';
      break;
    case 'N': // Send transmitter smoothing values
      serialPrintValueComma(0); // TODO? receiver transmit factor
      
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      Serial.println(0.0); // TODO?
      
      _queryType = 'X';
      break;
    case 'P': // Send transmitter calibration data
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      
      serialPrintValueComma(0.0); // TODO?
      serialPrintValueComma(0.0); // TODO?
      
      serialPrintValueComma(0.0); // TODO?
      Serial.println(0.0); // TODO?
      
      _queryType = 'X';
      break;
    case 'Q': // Send sensor data
      serialPrintValueComma(gyro.getRoll());
      serialPrintValueComma(gyro.getPitch());
      serialPrintValueComma(gyro.getYaw());

      serialPrintValueComma(accel.getRoll());
      serialPrintValueComma(accel.getPitch());
      serialPrintValueComma(accel.getYaw());
      
      serialPrintValueComma(0); // TODO: serialPrintValueComma(degrees(flightAngle->getData(ROLL)));
      serialPrintValueComma(0); // TODO: serialPrintValueComma(degrees(flightAngle->getData(PITCH)));
      
      serialPrintValueComma(0); // TODO: Heading
      serialPrintValueComma(0); // Altitude hold
      Serial.print(0); // Battery monitor
      Serial.println();
      break;
    case 'R': // Raw magnetometer data
      serialPrintValueComma(0);
      serialPrintValueComma(0);
      Serial.println('0');
      break;
    case 'S': // Send all flight data
      serialPrintValueComma(deltaTime);

      serialPrintValueComma(gyro.getRawRoll());
      serialPrintValueComma(gyro.getRawPitch()); // Negative?
      serialPrintValueComma(gyro.getRawYaw());

      serialPrintValueComma(0); // Battery monitor
      
      serialPrintValueComma(0); // TODO: Motor axis commands
      serialPrintValueComma(0); // TODO: Motor axis commands
      serialPrintValueComma(0); // TODO: Motor axis commands
      serialPrintValueComma(0); // TODO: Motor axis commands
      
      for (byte engine = 0; engine < ENGINE_COUNT; engine++){
        serialPrintValueComma(engines.getEngineSpeed(engine));
      }
      
      serialPrintValueComma(accel.getRawRoll());
      serialPrintValueComma(accel.getRawPitch());
      serialPrintValueComma(accel.getRawYaw());
      
      Serial.print(engines.isArmed(), BIN);
      serialComma();
      
      serialPrintValueComma(2000); // Stable flight mode
      
      serialPrintValueComma(0); // HeadingMagHold
      
      serialPrintValueComma(0); // Alt hold data
      Serial.print('0'); // Alt hold on
      
      Serial.println();
      break;
    case 'T': // Send processed transmitter values
      serialPrintValueComma(0); // TODO? receiver transmit factor
    
      serialPrintValueComma(0); // TODO? receiver roll
      serialPrintValueComma(0); // TODO? receiver pitch
      serialPrintValueComma(0); // TODO? receiver yaw
      
      serialPrintValueComma(0.0); // TODO? level adjust roll
      serialPrintValueComma(0.0); // TODO? level adjust pitch
      
      serialPrintValueComma(0); // TODO: motor axis roll
      serialPrintValueComma(0); // TODO: motor axis pitch
      Serial.println(0); // TODO: motor axis yaw
      
      break;
    case 'U': // Send smoothed receiver with Transmitter Factor applied values
      serialPrintValueComma(0); // TODO?
      serialPrintValueComma(0); // TODO?
      serialPrintValueComma(0); // TODO?
      serialPrintValueComma(0); // TODO?
      serialPrintValueComma(0); // TODO?
      Serial.println(0); // TODO?
      break;
    case 'V': // Send receiver status
      serialPrintValueComma(1000); // TODO?
      serialPrintValueComma(1000); // TODO?
      serialPrintValueComma(1000); // TODO?
      serialPrintValueComma(1000); // TODO?
      serialPrintValueComma(1000); // TODO?
      Serial.println(1000); // TODO?
      break;
    case 'X': // Stop sending messages
      break;
    case 'Z': // Send heading
      serialPrintValueComma(0); // TODO: receiver.getData(YAW)
      serialPrintValueComma(0.0); // TODO: headingHold
      serialPrintValueComma(0.0); // TODO: setHeading
      Serial.println(0.0); // TODO: relativeHeading
      break;
    case '6': // Report remote commands
      for (byte engine = 0; engine < ENGINE_COUNT-1; engine++){
        serialPrintValueComma(engines.getEngineSpeed(engine)); // TODO: These should be "remote commands"
      }
      Serial.println(engines.getEngineSpeed(ENGINE_COUNT-1)); // TODO: These should be "remote commands"
      break;
    case '!': // Send flight software version
      Serial.println(VERSION, 1);
      _queryType = 'X';
      break;
    case '#': // Send software configuration
      serialPrintValueComma(2); // Emulate AeroQuad_v18
      Serial.print('1'); // X-config
      Serial.println();
      _queryType = 'X';
      break;  
    case 'e': // Send AREF value
      Serial.println(5.0);
      _queryType = 'X';
      break;
    case 'g': // Send magnetometer cal values
      // IGNORED
      _queryType = 'X';
      break;
    case '`': // Send Camera values
      // IGNORED
      break;
  }
}

// Used to read floating point values from the serial port
float readFloatSerial(){
  #define SERIALFLOATSIZE 10
  byte index = 0;
  byte timeout = 0;
  char data[SERIALFLOATSIZE] = "";

  do {
    if (Serial.available() == 0) {
      delay(10);
      timeout++;
    }
    else {
      data[index] = Serial.read();
      timeout = 0;
      index++;
    }
  }  
  while ((index == 0 || data[index-1] != ';') && (timeout < 5) && (index < sizeof(data)-1));
  data[index] = '\0';
  return atof(data);
}

void serialPrintValueComma(float val){
  Serial.print(val);
  serialComma();
}

void serialPrintValueComma(double val){
  Serial.print(val);
  serialComma();
}

void serialPrintValueComma(char val){
  Serial.print(val);
  serialComma();
}

void serialPrintValueComma(int val){
  Serial.print(val);
  serialComma();
}

void serialPrintValueComma(unsigned long val){
  Serial.print(val);
  serialComma();
}

void serialComma(){
  Serial.print(',');
}

void serialPrintPID(unsigned char IDPid){
  serialPrintValueComma(0.0); // TODO: Make real
  serialPrintValueComma(0.0);
  serialPrintValueComma(0.0);
}