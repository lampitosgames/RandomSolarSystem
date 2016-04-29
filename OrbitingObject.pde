/**
 * The OrbitingObject Class
 * 
 * A superclass for anything that uses orbits to calculate motion
 */
class OrbitingObject {
  //Positions
  int xPos, yPos;
  float mass;
  
  /**
   * Constructor
   * 
   * @param mass  Mass value of the object (no units, all masses are relative values)
   */
  OrbitingObject(float mass) {
    //By default, set the object to the center of the screen.  This will always be updated before the first Draw() call
    this.xPos = screen.canvasWidth/2;
    this.yPos = screen.canvasHeight/2;
    //Save the object's mass
    this.mass = mass;
  }
  
  /**
   * Method stub for the default Draw method
   */
  void Draw() { 
  }
}