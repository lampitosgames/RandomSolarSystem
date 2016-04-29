/**
 * The Star Class
 * 
 * Stars have textures randomly generated form 2d perlin noise.
 * Of note here is my use of the pixel grid and drawing only pixels within the star's radius as perlin noise
 */
class Star extends OrbitingObject {
  //Star radius
  float solarRadius;
  //Elapsed time for perlin noise
  float elapsedTime;
  //HSB color values, passed in on construction and modified by noise values
  int hsb1, hsb2, hsb3;
  //Color of the star
  color backgroundColor;
  
  /**
   * Constructor
   * 
   * @param mass  Solar mass of the star
   * @param radius  Radius of the star (in pixels before scaling)
   * @param hsb1, hsb2, hsb3  Star base color
   */
  Star(float mass, float radius, int hsb1, int hsb2, int hsb3) {
    super(mass);
    this.solarRadius = radius;
    this.hsb1 = hsb1;
    this.hsb2 = hsb2;
    this.hsb3 = hsb3;
    this.backgroundColor = color(hsb1, hsb2, hsb3);
    //Random elapsed time start value.  Basically, new perlin noise seed.
    //Perlin noise gets a default seed at runtime, but it would be the same texture for all stars without this
    this.elapsedTime = random(5000);
  }
  
  /**
   * Default Draw Method
   *
   * Draw the star at its current location
   */
  void Draw() {
    //Set the color drawing mode so that perlin noise can be used as a percentage scalar to draw stars (everything else will be images, so no color is needed)
    colorMode(HSB, 255, 100, 100);
    
    //Increment the elapsed time for perlin noise
    elapsedTime += 1.0/frameRate;
    
    //Get the position on the screen to draw at
    int drawX = (int)(this.xPos*screen.viewScale - screen.viewX*screen.viewScale);
    int drawY = (int)(this.yPos*screen.viewScale - screen.viewY*screen.viewScale);
    /*
      Draw animated perlin noise as star's texture
    */
    //Load all pixels into the pixels[] array
    loadPixels();
    //Loop through the pixels in the window
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        //If the current pixel is within the circle ( P = {(x, y) : (x-m1)^2 + (y-m2)^2 <= r} where r is radius, (x, y) is the point, and (m1, m2) is the center )
        float dx = x - drawX;
        float dy = y - drawY;
        float distSquared = dx*dx + dy*dy;
        if (distSquared <= pow((int)(this.solarRadius*drawScale*screen.viewScale), 2)) {
          //Use HSB to set the darkness of the background color for this star
          pixels[x + y*width] = color(this.hsb1, this.hsb2, 20.0 + 80.0*noise(elapsedTime / 1.0, float(x - this.xPos) / 100.0, float(y - this.yPos) / 100.0));
        }
      }
    }
    //Update pixels
    updatePixels();
    //Reset the color mode
    colorMode(RGB);
  }
}