/**
 * The ThrustFlame Class
 * 
 * A blue flame that jetts out of spaceship engines and RCS thrusters
 */
class ThrustFlame {
  //Rectangular boundaries of the thrust flame.  It will always be contained in these
  int xPos, yPos, w, h;
  //Is the thrust flame visible
  boolean visible;
  
  //Time value for perlin noise
  float pTime;
  
  //Direction the flame faces
  int dir; //0 = up, 1=right, 2=down, 3=left
  
  //Blue-tined PShape that is used in conjunction with perlin noise to create a new shape every step
  PShape exhaust;
  
  /**
   * Constructor
   * 
   * @param xPos  Top-left corner x position
   * @param yPos  Top-left corner y position
   * @param flameWidth  Width of the flame
   * @param flameHeight  Height of the flame
   * @param dir  Direction of the flame
   */
  ThrustFlame(int xPos, int yPos, int flameWidth, int flameHeight, int dir) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.w = flameWidth;
    this.h = flameHeight;
    this.dir = dir;
    
    //Not visible by default
    this.visible = false;
    
    //Noise timer starts at 0
    this.pTime = 0.0;
  }
  
  /**
   * Default Draw Method
   */
  void Draw() {
    //If the thrust is visible
    if (this.visible) {
      //Increment the time
      this.pTime += 0.1;
      
      //Create a new shape
      this.exhaust = createShape();
      exhaust.beginShape();
      
      //Different code based on the direction
      //(There is probably an easier way to do this)
      /*
        Based on direction, vary one of the vertex variables using 2d perlin noise
      */
      switch (this.dir) {
        case 0:
          exhaust.vertex((int)(this.xPos*screen.viewScale), (int)((this.yPos+this.h)*screen.viewScale));
          for (int i=2; i<w; i+=2) {
            exhaust.vertex((int)((i+this.xPos-1)*screen.viewScale), (int)((this.yPos + map(noise(this.pTime, i/10.0), 0, 1, 0, this.h))*screen.viewScale));
          }
          exhaust.vertex((int)((xPos+w)*screen.viewScale), (int)((yPos+this.h)*screen.viewScale));
          break;
        case 1:
          
          break;
        case 2:
          exhaust.vertex((int)(this.xPos*screen.viewScale), (int)(this.yPos*screen.viewScale));
          for (int i=2; i<w; i+=2) {
            exhaust.vertex((int)((i+this.xPos-1)*screen.viewScale), (int)((this.yPos + map(noise(this.pTime, i/10.0), 0, 1, 0, this.h))*screen.viewScale));
          }
          exhaust.vertex((int)((xPos+w)*screen.viewScale), (int)(yPos*screen.viewScale));
          break;
        case 3:
          exhaust.vertex((int)((this.xPos+this.w)*screen.viewScale), (int)(this.yPos*screen.viewScale));
          for (int i=2; i<h; i+=2) {
            exhaust.vertex((int)(this.xPos*screen.viewScale)+(int)((map(noise(this.pTime, i/10.0), 0, 1, 0, this.w))*screen.viewScale), (int)((i+this.yPos-1)*screen.viewScale));
          }
          exhaust.vertex((int)((xPos+w)*screen.viewScale), (int)((yPos+h)*screen.viewScale));
          break;
      }
      exhaust.endShape(CLOSE);
      
      shape(this.exhaust);
    }
  }
}