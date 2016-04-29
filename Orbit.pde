/**
 * The Orbit Class
 *
 * Represents the orbit of an OrbitingObject in the System
 */
class Orbit {
  //Object that is orbiting, its position changing with time
  OrbitingObject object;
  
  //Position (in angle from positive x axis) of the object
  float theta;
  //Radius of the orbit
  float radius;
  //Speed the object moves (deg/sec)
  float speed;
  //Center position of this orbit
  float centerX, centerY;
  
  /**
   * Constructor
   * 
   * @param thisObject  Object that this orbital path represents
   * @param dir  Direction of the orbit (negative or positive)
   * @param centerMass  Total mass of the system
   * @param cX  X position of orbit center
   * @param cY  Y position of orbit center
   */
  Orbit(OrbitingObject thisObject, int dir, float centerMass, float cX, float cY) {
    //Save local variables
    this.object = thisObject;
    this.centerX = cX;
    this.centerY = cY;
    
    
    //Calculate the distance to the object
    float distToObject = sqrt(pow(this.object.xPos - this.centerX, 2) + pow(this.object.yPos - this.centerY, 2));
    
    //Get the object's orbital velocity (deg/sec) using physics equation
    this.speed = sqrt((gravConst*(centerMass+this.object.mass))/(distToObject)) * dir;
    
    //Get the object's position relative to the orbit's center (relative coordinates)
    float deltaX = this.object.xPos - this.centerX;
    float deltaY = this.object.yPos - this.centerY;
    
    //Calculate the radius of the orbit based on the center (x, y) and the object (x, y)
    this.radius = sqrt(deltaX*deltaX + deltaY*deltaY);
    
    //Make sure the delta is non-zero.  A delta of zero results in errors.
    if (deltaY == 0 && deltaX == 0) {
       deltaY = 1;
       deltaX = 1;
    }
    
    //Calculate the theta (angle from 0 deg to this object) for the initial position, to change at a rate of <speed>/second
    this.theta = degrees(atan(deltaY/deltaX));
    
    //If the coordinate signs are the same (pos, pos || neg, neg), the theta would be the same.  If the coordinate signs are opposite, the theta will be the same.  Detect for this.
    //Essentially, if the x and y locations start out with the same sign, you can't determine if they are in quadrant 1 or quadrant 3.  Same for quad 2 and 4 with opposite signs.
    //If x is positive, don't flip 180
    if (deltaX < 0) {
      this.theta += 180;
    }
    
    //Move the object into position
    this.object.xPos = int(this.centerX + cos(radians(this.theta))*this.radius);
    this.object.yPos = int(this.centerY + sin(radians(this.theta))*this.radius);
  }
  
  /**
   * The default Update method
   */
  void Update() {
    //Update the x and y position of the orbit object
    //Only update if the radius > 0
    if (this.radius > 0) {
      //Add the speed (adjusted for framerate) to the theta.  This lets the object move at a constant rate with a variable framerate.  Perlin noise is slow!
      this.theta += speed/frameRate;
      //Update the object's position
      this.object.xPos = int(this.centerX + cos(radians(this.theta))*this.radius);
      this.object.yPos = int(this.centerY + sin(radians(this.theta))*this.radius);
    }
  }
}