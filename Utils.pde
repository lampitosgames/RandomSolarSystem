/**
 * Utils
 */
static class Utils {
  //Restricts an integer value to a given range
  static int Clamp(int min, int max, int value) {
    return min(max(value, min), max);
  }
  
  //Does the same as Clamp() but for doubles
  static double ClampDouble(double min, double max, double value) {
    //The logic here is doing the same thing as Clamp(), but manually because min/max don't work for doubles in this language?
    double ma1;
    if (value > min) {
      ma1 = value;
    } else {
      ma1 = min;
    }
    
    if (ma1 > max) {
      return max;
    } else {
      return ma1;
    }
  }
  
  //Clamps angle values to 0-360 and turns negative angles into positive ones
  static float UnwrapAngle(float angle) {
    float tempAngle;
    if (angle >= 0) {
      tempAngle = angle % 360;
    //Angle is less than 0, change it
    } else {
      tempAngle = (360 - (-1*angle)) % 360;
    }
    return tempAngle;
  }
  
  //Gets the smallest arc length between the angle
  static float ArcLen(float angle1, float angle2) {
    //Get the distance in one direction
    float size1 = angle2 - angle1;
    //Get the distance in the other
    float size2 = -1*Utils.UnwrapAngle(angle1 + (360-angle2));
    //Return the arc length with the largest size, positive or negative
    return abs(size1) >= abs(size2) ? size2 : size1;
  }
}