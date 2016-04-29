/**
 * The Planet Class
 * 
 * Planets are orbiting objects that move around the solar system.  They have a possibility to generate with moons.
 */
class Planet extends OrbitingObject {
  //Relative image width/height. Planet source images are 512px by 512px
  int imageWidth, imageHeight;
  
  //Array of image file names for planets
  String[] strings;
  //PImage for the image that is chosen
  PImage planetImg;
  
  //ArrayList of moons orbiting this planet
  ArrayList<Orbit> moonOrbits;
  
  /**
   * Constructor
   * 
   * @param mass  Mass of this planet
   */
  Planet(float mass) {
    //Call the superclass' constructor
    super(mass);
    
    //Set the image width and height based on the draw scale
    this.imageWidth = (int)(64.0*pDrawScale);
    this.imageHeight = (int)(64.0*pDrawScale);
    
    //Add all possible planetary images to the strings array
    strings = new String[14];
    strings[0] = "p01.png";
    strings[1] = "p02.png";
    strings[2] = "p03.png";
    strings[3] = "p04.png";
    strings[4] = "p05.png";
    strings[5] = "p06.png";
    strings[6] = "p07.png";
    strings[7] = "p08.png";
    strings[8] = "p09.png";
    strings[9] = "p10.png";
    strings[10] = "p11.png";
    strings[11] = "p12.png";
    strings[12] = "p13.png";
    strings[13] = "p14.png";
    
    //Pick one from that list
    this.planetImg = loadImage(strings[(int)random(0, 14)]);
    
    //Generate moons (if any)
    //Initialize the moon orbit object
    moonOrbits = new ArrayList<Orbit>();
    //40% chance to have a moon
    int hasMoons = (int)random(100);
    if (hasMoons < 40) {
      //How many moons?  between 1 and 3
      int numMoons = (int)random(1, 4);
      //Set the initial radius
      float initialRadius = this.imageWidth;
      float orbitBeltSize = 16.0*pDrawScale+8.0*pDrawScale;
      
      //For every moon to spawn
      for (int m=0; m<numMoons; m++) {
        //Create a new moon with a random mass
        Moon curMoon = new Moon(this, random(3.0, 7.0));
        //Which direction does this moon orbit?
        float moonDirRandom= random(-5, 5);
        int moonDir;
        if (moonDirRandom >= 0) {
          moonDir = 1;
        } else {
          moonDir = -1;
        }
        //Create a new orbit for the moon
        float orbitRadius = m*orbitBeltSize + initialRadius;
        
        //Get a random angle for this planet to start at
        float randTheta = random(361);
        
        
        //Set the X and Y of the moon
        curMoon.xPos = int(this.xPos + cos(radians(randTheta))*orbitRadius);
        curMoon.yPos = int(this.yPos + sin(radians(randTheta))*orbitRadius);
        
        this.moonOrbits.add(new Orbit(curMoon, moonDir, this.mass, this.xPos, this.yPos));
      }
    }
  }
  
  /**
   * Default Draw Method
   */
  void Draw() {
     //Update all moon orbits
     for (int j=0; j<this.moonOrbits.size(); j++) {
       Orbit thisOrbit = this.moonOrbits.get(j);
       thisOrbit.centerX = this.xPos;
       thisOrbit.centerY = this.yPos;
       thisOrbit.Update();
       //Draw orbit lines
       stroke(255, 255, 255, 75);
       noFill();
       ellipseMode(RADIUS);
       ellipse((float)(thisOrbit.centerX*screen.viewScale-screen.viewX*screen.viewScale),
               (float)(thisOrbit.centerY*screen.viewScale-screen.viewY*screen.viewScale),
               (float)(thisOrbit.radius*screen.viewScale),
               (float)(thisOrbit.radius*screen.viewScale));
       //Draw the moon
       thisOrbit.object.Draw();
     }
    //Draw this planet's image
    image(this.planetImg,
          (int)((this.xPos-this.imageWidth/2)*screen.viewScale - screen.viewX*screen.viewScale), //XPos in window
          (int)((this.yPos-this.imageHeight/2)*screen.viewScale - screen.viewY*screen.viewScale), //YPos in window
          (int)(imageWidth*screen.viewScale), //Width
          (int)(imageHeight*screen.viewScale)); //Height
  }
}