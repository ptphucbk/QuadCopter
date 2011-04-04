/*
  IMU.h - Library for combining my accel and gyro data into one nice set of headings/angles
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
#ifndef IMU_h
#define IMU_h

#include "WProgram.h"
#include "Definitions.h"

class IMU
{
  public:
    IMU();
    
    void update(float, float, float, float, float, float);
    
    float getRoll();
    float getPitch();
    float getHeading();
  
  private:
    void updateAxis(byte, float, float);
  
    float data[3];
    
    float _dt; // Constant loop rate
    float _timeConstant; // How much bias to accel vs gyro?
};

#endif
