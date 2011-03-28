/*
  Accel.cpp - Library for interfacing with the ADXL345 accelerometer (specifically, via the Sparkfun IMU Digital Combo Board: SEN-10121)
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

#include "WProgram.h"
#include "Definitions.h"
#include "Accel.h"
#include "I2C.h"

Accel::Accel(){
}

void Accel::init(){
  Serial.println("Initing Accel");
  _i2c = I2C(ACCEL_ADDR);
  
  if (!_i2c.getAddressFromDevice()){
    Serial.println("ACCEL NOT CONNECTED!");
  }
  else{
    //_i2c.writeSetting(0x3E, 0x80); // Reset it
  }
}