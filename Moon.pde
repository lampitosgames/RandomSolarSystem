/**
 * The Moon Class
 *
 * Moons extend OrbitingObjects, meaning they are affected by orbits.  They are the simplest of orbiting objects
 */
class Moon extends OrbitingObject {
  //Relative image width/height. Moon source images are 128px by 128px
  int imageWidth, imageHeight;
  
  //List of image file names
  String[] strings;
  
  //Image for this moon
  PImage moonImage;
  
  /**
   * Constructor
   * 
   * @param parent  The planet this moon is orbiting
   * @param mass  Mass of this moon
   */
  Moon(Planet parent, float mass) {
    //Call the superclass constructor
    super(mass);
    
    //Set the image width and height based on the default scale
    this.imageWidth = (int)(16.0*pDrawScale);
    this.imageHeight = (int)(16.0*pDrawScale);
    
    //Choose a moon image at random
    //Create an array of possible images
    strings = new String[5];
    strings[0] = "moon1.png";
    strings[1] = "moon2.png";
    strings[2] = "moon3.png";
    strings[3] = "moon4.png";
    strings[4] = "moon5.png";
    
    //Pick one from that list and load it
    this.moonImage = loadImage(strings[(int)random(0, 5)]);
  }
  
  /**
   * Default Draw Method
   */
  void Draw() {
    //Draw this moon's image
    image(this.moonImage,
          (int)((this.xPos-this.imageWidth/2)*screen.viewScale - screen.viewX*screen.viewScale), //XPos in window
          (int)((this.yPos-this.imageHeight/2)*screen.viewScale - screen.viewY*screen.viewScale), //YPos in window
          (int)(imageWidth*screen.viewScale), //Width
          (int)(imageHeight*screen.viewScale)); //Height
  }
}