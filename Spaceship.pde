/**
 * The Spaceship Class
 * 
 * This is the focal point of this sketch.  The spaceship gets its velocity magnitude added every frame to it's location.
 * It also has a chance to turn randomly and have its velocity changed.
 */
class Spaceship {
  //Is the view following the spaceship
  boolean viewSnap;
  
  //Image of the ship
  PImage shipImage;
  
  //Perlin-noise thrust animations for each engine that can be toggled on and off
  ThrustFlame thrust1, thrust2, thrustLeft1, thrustLeft2, thrustRight1, thrustRight2;
  
  //Vectors for the ships position and velocity
  PVector pos, vel;
  
  //Rotation variables
  float targetAngle, rSpeed;
  boolean rotateAnim;
  
  //What chance each frame does the ship have of rotating
  float rotationChance;
  //What chance each frame does the ship have of changing velocity
  float velocityChance;
  
  /**
   * Constructor
   */
  Spaceship() {
    //The view is following the ship by default
    this.viewSnap = true;
    
    //Set the starting position to the center
    this.pos = new PVector(screen.canvasWidth/2, screen.canvasHeight/2);
    
    //Set initial velocity to 0 (or very close, needs to have some magnitude or else rotation won't work)
    this.vel = new PVector(0.0000001, 0);
    //Set the velocity change chance to 5%
    this.velocityChance = 5.0;
    
    //Set the initial angle and rotational speed of the ship (deg/sec)
    this.targetAngle = 0;
    this.rSpeed = 30;
    this.rotationChance = 1.0;
    
    //Create backwards thrust objects
    thrust1 = new ThrustFlame(-178, 14, 30, 16, 3);
    thrust1.visible = true;
    thrust2 = new ThrustFlame(-178, -29, 30, 16, 3);
    thrust2.visible = true;
    
    //Create left thrust objects
    thrustLeft1 = new ThrustFlame(-84, -41, 7, 20, 0);
    thrustLeft1.visible = true;
    thrustLeft2 = new ThrustFlame(72, -63, 7, 30, 0);
    thrustLeft2.visible = true;
    
    //Create right thrust objects
    thrustRight1 = new ThrustFlame(-84, 21, 7, 20, 2);
    thrustRight1.visible = true;
    thrustRight2 = new ThrustFlame(72, 33, 7, 30, 2);
    thrustRight2.visible = true;
    
    //Load the spaceship image
    shipImage = loadImage("mainShip.png");
  }
  
  /**
   * Default Draw Method
   * 
   * The spaceship is drawn using relative coordinates by translating to its x and y position (calculated for view)
   */
  void Draw() {
    /*
      Calculations
    */
    //Get the vector angle
    int VA = (int)Utils.UnwrapAngle(degrees(this.vel.heading()));
    
    //Get the target angle
    int tempTA = (int)Utils.UnwrapAngle(this.targetAngle);
    
    //If the vector angle isn't the ship's target angle, rotate the ship
    if (VA != tempTA) {
      //Set the animation status to rotating so that nothing changes
      this.rotateAnim = true;
      
      //Determine what is faster, counterclockwise or clockwise rotation
      //If the shortest arc between the current rotation and the target rotation is negative
      if (Utils.ArcLen(VA, tempTA) < 0) {
        //If rotating 1 step in the negative direction bypasses the temp angle
        if (abs(tempTA - VA) < this.rSpeed/frameRate) {
          //Rotate exactly to the target angle
          this.vel.rotate(radians(tempTA - VA));
        //Else, a single step won't make it to the target angle
        } else {
          //Subtract the rotation speed from the angle
          this.vel.rotate(radians(-1*this.rSpeed/frameRate));
        }
        //Turn on rotational thrusters
        this.thrustLeft1.visible = true;
        this.thrustRight2.visible = true;
      
      //Rotating in the positive direction is the shortest way to the target
      } else {
        if (abs(tempTA - VA) < this.rSpeed/frameRate) {
          this.vel.rotate(radians(tempTA - VA));
        } else {
          this.vel.rotate(radians(this.rSpeed/frameRate));
        }
        this.thrustLeft2.visible = true;
        this.thrustRight1.visible = true;
      }
    
    //The ship isn't rotating
    } else {
      this.thrustLeft1.visible = false;
      this.thrustRight1.visible = false;
      this.thrustLeft2.visible = false;
      this.thrustRight2.visible = false;
      this.rotateAnim = false;
    }
    
    //If the ship is not currently in a rotation
    if (this.rotateAnim == false) {
      //Should the ship rotate?
      float randRotation = random(100);
      if (randRotation < this.rotationChance) {
        //If yes, then how much?
        this.targetAngle = random(360);
        //Set a random rotational speed (gaussian)
        this.rSpeed = map(randomGaussian(), -4, 4, 20, 60);
      }
    }
    //Random chance to change the velocity
    float randVelocity = random(100);
    if (randVelocity < this.velocityChance) {
      //Set a random velocity magnitude (gaussian)
      this.vel.setMag(map(randomGaussian(), -4, 4, 3, 9));
    }
    //Add the velocity to the position
    this.pos.add(this.vel);
    
    if (this.viewSnap) {
      screen.MoveView((int)(this.pos.x - (screen.viewWidth/2)/screen.viewScale), (int)(this.pos.y - (screen.viewHeight/2)/screen.viewScale));
    }
    
    /*
      Draw code
    */
    noStroke();
    colorMode(RGB);
    fill(82, 231, 255, 150);
    
    pushMatrix();
    translate((int)(this.pos.x*screen.viewScale - screen.viewX*screen.viewScale), (int)(this.pos.y*screen.viewScale - screen.viewY*screen.viewScale));
    rotate(this.vel.heading());
    this.thrust1.Draw();
    this.thrust2.Draw();
    image(this.shipImage, (int)(-162*screen.viewScale), (int)(-67*screen.viewScale), (int)(324*screen.viewScale), (int)(134*screen.viewScale));
    this.thrustLeft1.Draw();
    this.thrustLeft2.Draw();
    this.thrustRight1.Draw();
    this.thrustRight2.Draw();
    popMatrix();
  }
}